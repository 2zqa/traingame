extends Reference
class_name Rails


const _TILE_LENGTH = 16  # Length of one tile on the grid. Note that rail objects can span multiple tiles.
const _HALF_TILE_SIZE = Vector2(_TILE_LENGTH, _TILE_LENGTH) / 2
const _SMALL_VALUE = 0.001

class RailPathSegment extends Reference:
    func _init():
        # Do not create instances - this is an abstract base class
        pass
    
    #warning-ignore:unused_argument
    func get_increased_position(position: Vector2, direction: int, amount: float) -> Array:
        # Requires a position (in pixels, relative to the top left of the object)
        # and the amount to increase (also in pixels)
        # Returns three values: (new_position, new_direction, remaining_amount)
        # If remaining_amount is not 0, then you'll need to find out in which tile you are now,
        # what object is there, recalculate the offset position and check again for the increased position
        return [position, direction, 0]  # This derails the train. Overridden in subclasses.    


class _ShortVerticalSegment extends RailPathSegment:
    
    func get_increased_position(position: Vector2, direction: int, amount: float) -> Array:
        if direction != Direction.NORTH and direction != Direction.SOUTH:
            return [position, direction, 0]  # Derailed, driving in wrong direction
        var delta_y = amount
        if direction == Direction.NORTH:
            delta_y = -amount
        var new_y = position.y + delta_y
        if new_y < 0:
            # Need to continue on previous tile
            if new_y > -_SMALL_VALUE:
                # Stop juuuuust before this tile starts
                return [Vector2(_TILE_LENGTH / 2.0, -_SMALL_VALUE), direction, 0]
            return [Vector2(-_TILE_LENGTH / 2.0, -_SMALL_VALUE), direction, -new_y - _SMALL_VALUE]
        if new_y >= _TILE_LENGTH:
            # Need to continue on next tile
            return [Vector2(_TILE_LENGTH / 2.0, _TILE_LENGTH), direction, new_y - _TILE_LENGTH]
        # Stop within bounds
        return [Vector2(_TILE_LENGTH / 2.0, new_y), direction, 0]


class _RotatedSegment extends RailPathSegment:

    var _original_segment: RailPathSegment
    var _rotation: int

    func _init(original_segment: RailPathSegment, rotation: int):
        self._original_segment = original_segment
        self._rotation = rotation

    func get_increased_position(position: Vector2, direction: int, amount: float) -> Array:
        var rotated_position = self._rotate(position)
        var result = self._original_segment.get_increased_position(rotated_position, direction, amount)
        result[0] = self._unrotate(result[0])
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

