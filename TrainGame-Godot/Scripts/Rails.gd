extends Reference
class_name Rails


const _TILE_LENGTH = 16  # Length of one tile on the grid. Note that rail objects can span multiple tiles.
const _HALF_TILE_SIZE = Vector2(_TILE_LENGTH, _TILE_LENGTH) / 2
const _SMALL_VALUE = 0.01

class RailPathSegment extends Reference:
    func _init():
        # Do not create instances - this is an abstract base class
        pass
    
    # Requires a position (in pixels, relative to the top left of the object)
    # and the amount to increase (also in pixels, can be positive)
    # Returns three values: (new_position, new_direction, remaining_amount)
    # If remaining_amount is not 0, then you'll need to find out in which tile you are now,
    # what object is there, recalculate the offset position and check again for the increased position
    #warning-ignore:unused_argument
    func get_increased_position(position: Vector2, direction: int, amount: float) -> Array:
        return [position, direction, 0]  # This derails the train. Overridden in subclasses.    


class _ShortVerticalSegment extends RailPathSegment:
    
    func get_increased_position(position: Vector2, direction: int, amount: float) -> Array:
        if direction != Direction.NORTH and direction != Direction.SOUTH:
            return [position, direction, 0]  # Derailed, driving in wrong direction

        var new_position
        if direction == Direction.NORTH:
            new_position = Vector2(_TILE_LENGTH / 2, position.y - amount)
        else:
            new_position = Vector2(_TILE_LENGTH / 2, position.y + amount)

        var remaining_amount = 0
        if new_position.y < 0:
            # Need to continue on north neighbor tile
            var overflow_amount = abs(new_position.y)
            if direction == Direction.NORTH:
                remaining_amount = overflow_amount
            else:
                remaining_amount = -overflow_amount
            new_position.y = -_SMALL_VALUE  # Limit y
        if new_position.y >= _TILE_LENGTH:
            # Need to continue on south neighbor tile
            var overflow_amount = new_position.y - _TILE_LENGTH
            if direction == Direction.SOUTH:
                remaining_amount = overflow_amount
            else:
                remaining_amount = -overflow_amount
            new_position.y = _TILE_LENGTH  # Limit y
        # Stop within bounds
        return [new_position, direction, remaining_amount]

    func _to_string() -> String:
        return "ShortVerticalSegment"


class _RotatedSegment extends RailPathSegment:

    var _original_segment: RailPathSegment
    var _rotation: int

    func _init(original_segment: RailPathSegment, rotation: int):
        self._original_segment = original_segment
        self._rotation = rotation

    func get_increased_position(position: Vector2, direction: int, amount: float) -> Array:
        var rotated_position = self._rotate(position)
        var rotated_direction = Direction.rotate(direction, self._rotation)
        var result = self._original_segment.get_increased_position(rotated_position, rotated_direction, amount)
        result[0] = self._unrotate(result[0])
        result[1] = Direction.unrotate(result[1], self._rotation)
        return result

    func _rotate(position: Vector2) -> Vector2:
        position -= _HALF_TILE_SIZE  # Move to center of tile for rotation
        position = Rotation.rotate(self._rotation, position)
        position += _HALF_TILE_SIZE  # Move back
        return position

    func _unrotate(position: Vector2) -> Vector2:
        position -= _HALF_TILE_SIZE  # Move to center of tile for rotation
        position = Rotation.unrotate(self._rotation, position)
        position += _HALF_TILE_SIZE  # Move back
        return position

    func _to_string() -> String:
        return "RotatedSegment(" + str(self._original_segment) + ", " + \
                Rotation.rotation_to_string(self._rotation) + ")"

static func no_rail() -> RailPathSegment:
    # Used when no rail is present.
    return RailPathSegment.new()

# Gets the short, straight, vertical rail.
static func short_straight_rail() -> RailPathSegment:
    return _ShortVerticalSegment.new()

# Gets a rotated version of the given rail.
static func with_rotation(rail: RailPathSegment, rotation: int) -> RailPathSegment:
    if rail is _RotatedSegment:
        rail = rail._original_segment  # Don't stack multiple objects
    if rotation == Rotation.NONE:
        return rail  # Don't need special transformations here
    return _RotatedSegment.new(rail, rotation)

