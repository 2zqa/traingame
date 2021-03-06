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
    # and the amount to increase (also in pixels, can only be positive)
    # Returns three values: (new_position, new_direction, remaining_amount)
    # If remaining_amount is not 0, then you'll need to find out in which tile you are now,
    # what object is there, recalculate the offset position and check again for the increased position
    #warning-ignore:unused_argument
    func get_increased_position(position: Vector2, direction: int, amount: float) -> Array:
        return [position, direction, 0]  # This derails the train. Overridden in subclasses.    

class _VerticalRailSegment extends RailPathSegment:
    
    var _rail_length: int
    var _rail_offset_x: int
    var _rail_offset_y: int
    
    func _init(tile_offset: Vector2, tile_size: int):
        self._rail_offset_x = int(tile_offset.x * _TILE_LENGTH)
        self._rail_offset_y = int(tile_offset.y * _TILE_LENGTH)
        self._rail_length = tile_size * _TILE_LENGTH
    
    func get_increased_position(position: Vector2, direction: int, amount: float) -> Array:
        if direction != Direction.NORTH and direction != Direction.SOUTH:
            return [position, direction, 0]  # Derailed, driving in wrong direction

        # Calculate new position without restrictions
        var new_x = self._rail_offset_x + _TILE_LENGTH / 2.0
        var new_y = position.y
        if direction == Direction.NORTH:
            new_y -= amount
        else:
            new_y += amount

        # Check whether we need to jump to a new tile
        if new_y < self._rail_offset_y:
            return [Vector2(new_x, self._rail_offset_y - _SMALL_VALUE), Direction.NORTH,
             self._rail_offset_y - new_y]
        if new_y >= self._rail_offset_y + self._rail_length:
            return [Vector2(new_x, self._rail_offset_y + self._rail_length + _SMALL_VALUE), Direction.SOUTH,
             new_y - self._rail_offset_y - self._rail_length]
        # Stop within bounds
        return [Vector2(new_x, new_y), direction, 0]

    func _to_string() -> String:
        return "ShortVerticalSegment"



class _CornerRailSegment extends RailPathSegment:
    #                      __
    # Corner orientation: |
    
    func get_increased_position(position: Vector2, direction: int, amount: float) -> Array:
        # We're driving on a circle with R = 2.5 * _TILE_LENGTH
        var amount_anticlockwise = amount
        if direction == Direction.NORTH or direction == Direction.EAST:
            amount_anticlockwise *= -1
        # Entire circle (2 PI radians) is 2 * pi * r in length. 
        var r = 2.5 * _TILE_LENGTH
        var amount_radians_anticlockwise = amount_anticlockwise / r
        
        var dx_to_center_of_circle_px = position.x - 2 * _TILE_LENGTH 
        var current_angle = acos(clamp(dx_to_center_of_circle_px / r, -1, 0))
        # current_angle will range from 0.5pi to pi
        var next_angle = current_angle + amount_radians_anticlockwise
        if next_angle >= PI:
            # Exit to the bottom, making sure sign(amount) matches
            var remaining_amount = (next_angle - PI) * r
            return [Vector2(-0.5 * _TILE_LENGTH, _TILE_LENGTH * 2 + _SMALL_VALUE), Direction.SOUTH, remaining_amount]
        if next_angle <= 0.5 * PI:
            # Exit to the right, making sure sign(amount) matches
            var remaining_amount = (0.5 * PI - next_angle) * r
            return [Vector2(_TILE_LENGTH * 2 + _SMALL_VALUE, -0.5 * _TILE_LENGTH), Direction.EAST, remaining_amount]
        # Within range
        return [Vector2(cos(next_angle) * r + 2 * _TILE_LENGTH, 2 * _TILE_LENGTH - sin(next_angle) * r), direction, 0]

    func _to_string() -> String:
        return "CornerRailSegment"



class _RotatedSegment extends RailPathSegment:

    var _original_segment: RailPathSegment
    var _rotation: int

    func _init(original_segment: RailPathSegment, rotation: int):
        self._original_segment = original_segment
        self._rotation = rotation

    func get_increased_position(position: Vector2, direction: int, amount: float) -> Array:
        var rotated_position = self._unrotate(position)
        var rotated_direction = Direction.unrotate(direction, self._rotation)
        var result = self._original_segment.get_increased_position(rotated_position, rotated_direction, amount)
        result[0] = self._rotate(result[0])
        result[1] = Direction.rotate(result[1], self._rotation)
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

    
class _CrossingRailSegment extends RailPathSegment:
    
    var _horizontal_rail: RailPathSegment
    var _vertical_rail: RailPathSegment
    
    func _init():
        self._vertical_rail = _VerticalRailSegment.new(Vector2(0, 0), 1)
        self._horizontal_rail = _RotatedSegment.new(self._vertical_rail, Rotation.CLOCKWISE)
    
    func get_increased_position(position: Vector2, direction: int, amount: float) -> Array:
        if direction == Direction.NORTH or direction == Direction.SOUTH:
            return self._vertical_rail.get_increased_position(position, direction, amount)
        return self._horizontal_rail.get_increased_position(position, direction, amount)

static func no_rail() -> RailPathSegment:
    # Used when no rail is present.
    return RailPathSegment.new()

# Gets the short, straight, vertical rail.
static func short_vertical_rail() -> RailPathSegment:
    return _VerticalRailSegment.new(Vector2(0, 0), 1)

# Gets a straight, vertical rail that is three tiles long and one tile wide.
static func long_vertical_rail() -> RailPathSegment:
    return _VerticalRailSegment.new(Vector2(0, -1), 3)

# Gets the corner rail, oriented as:  __
# Occupies 3x3 tiles                 |
static func corner_rail() -> RailPathSegment:
    return _CornerRailSegment.new()

# Gets the crossing rail, oriented as +. Occupies 1x1 tile.
static func crossing_rail() -> RailPathSegment:
    return _CrossingRailSegment.new()

# Gets a rotated version of the given rail. If the rail is already rotated, it
# is rotated further.
static func rotate(rail: RailPathSegment, rotation: int) -> RailPathSegment:
    if rail is _RotatedSegment:
        # Don't stack multiple objects
        rotation = Rotation.sum(rotation, rail._rotation)
        rail = rail._original_segment
    if rotation == Rotation.NONE:
        return rail  # Don't need special transformations here
    return _RotatedSegment.new(rail, rotation)

# Gets all possible rotations of the rail.
static func all_rotations(rail: RailPathSegment) -> Array:
    return [rail, rotate(rail, Rotation.CLOCKWISE),
        rotate(rail, Rotation.HALF),
        rotate(rail, Rotation.COUNTER_CLOCKWISE)]
    
