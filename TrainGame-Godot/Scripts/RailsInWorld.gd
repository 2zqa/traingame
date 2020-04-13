# Class that represents all the rails in the world.
class_name RailsInWorld


# Creates a curve out of the Vector2 array of points.
func _curve(points: Array) -> Curve2D:
    var curve = Curve2D.new()
    for point in points:
        curve.add_point(point)
    return curve

# Curves are relative to the *center* of the tile.
var _straight_line: Curve2D
var _straight_line_long: Curve2D  # Used for rail switches
var _corner_south_west: Curve2D  # Changes train direction from south to west
var _corner_east_north: Curve2D  # Changes train direction from east to north
var _sentinel: Curve2D

var _objects: ObjectsTileMap

func _init(objects: ObjectsTileMap):
    self._objects = objects
    self._straight_line = _curve([Vector2(0, 8), Vector2(0, -8)])
    self._straight_line_long = _curve([Vector2(0, 24), Vector2(0, -24)])
    self._corner_south_west = _curve([Vector2(16, -24), Vector2(13, -12), Vector2(3, 3), Vector2(-5, 9), Vector2(-16, 14), Vector2(-24, 16)])
    self._corner_east_north = _curve([Vector2(-24, 16), Vector2(-16, 14), Vector2(-5, 9), Vector2(3, 3), Vector2(13, -12), Vector2(16, -24)])
    self._sentinel = Curve2D.new()

func _driving_curve(curve: Curve2D, rotation: int) -> Curve2D:
    var translation = Rotation.rotate(rotation, curve.get_point_position(0))  # This makes the path start at (0, 0)
    var new_curve = Curve2D.new()
    var point_count = curve.get_point_count()
    for i in range(point_count):
        new_curve.add_point(Rotation.rotate(rotation, curve.get_point_position(i)) - translation)
    return new_curve

# Gets the rail path for the given tile positions. Returns a path of zero length in
# case the train is not riding a rail in the correct direction.
func get_path(input_tile_pos: Vector2, driving_direction: int) -> Curve2D:
    var object_tile = self._objects.get_tile(input_tile_pos)
    
    # Standard rails
    if Global.Registry.RAIL_STRAIGHT.equals_ignore_rotation(object_tile) \
            or Global.Registry.RAIL_WITHOUT_SLEEPERS.equals_ignore_rotation(object_tile):
        if object_tile.rotation == Rotation.NONE or object_tile.rotation == Rotation.HALF:
            if driving_direction == Direction.NORTH:
                return self._driving_curve(self._straight_line, Rotation.NONE)
            elif driving_direction == Direction.SOUTH:
                return self._driving_curve(self._straight_line, Rotation.HALF)
            else:
                return self._sentinel  # Cannot approach a vertical rail from this direction
        elif object_tile.rotation == Rotation.CLOCKWISE or object_tile.rotation == Rotation.COUNTER_CLOCKWISE:
            if driving_direction == Direction.EAST:
                return self._driving_curve(self._straight_line, Rotation.CLOCKWISE)
            elif driving_direction == Direction.WEST:
                return self._driving_curve(self._straight_line, Rotation.COUNTER_CLOCKWISE)
            else:
                return self._sentinel  # Cannot approach a horizontal rail from this direction
    
    # Rail crosses road
    if Global.Registry.RAIL_CROSSING_ROAD.equals_ignore_rotation(object_tile):
        # (rotation is different than for normal rails, as the rotation is from
        #  the perspective of the road)
        if object_tile.rotation == Rotation.CLOCKWISE or object_tile.rotation == Rotation.COUNTER_CLOCKWISE:
            if driving_direction == Direction.NORTH:
                return self._driving_curve(self._straight_line_long, Rotation.NONE)
            elif driving_direction == Direction.SOUTH:
                return self._driving_curve(self._straight_line_long, Rotation.HALF)
            else:
                return self._sentinel  # Cannot approach a vertical rail from this direction
        elif object_tile.rotation == Rotation.NONE or object_tile.rotation == Rotation.HALF:
            if driving_direction == Direction.EAST:
                return self._driving_curve(self._straight_line_long, Rotation.CLOCKWISE)
            elif driving_direction == Direction.WEST:
                return self._driving_curve(self._straight_line_long, Rotation.COUNTER_CLOCKWISE)
            else:
                return self._sentinel  # Cannot approach a horizontal rail from this direction
    
    # Corner-case
    if Global.Registry.RAIL_CORNER.equals_ignore_rotation(object_tile):
        if object_tile.rotation == Rotation.NONE:  # bottom-right
            if driving_direction == Direction.NORTH:
                return self._driving_curve(self._corner_south_west, Rotation.HALF)
            elif driving_direction == Direction.WEST:
                return self._driving_curve(self._corner_east_north, Rotation.HALF)
            else:
                return self._sentinel
        if object_tile.rotation == Rotation.CLOCKWISE:  # left-bottom
            if driving_direction == Direction.NORTH:
                return self._driving_curve(self._corner_east_north, Rotation.COUNTER_CLOCKWISE)
            elif driving_direction == Direction.EAST:
                return self._driving_curve(self._corner_south_west, Rotation.COUNTER_CLOCKWISE)
            else:
                return self._sentinel
        if object_tile.rotation == Rotation.HALF:  # top-left
            if driving_direction == Direction.SOUTH:
                return self._driving_curve(self._corner_south_west, Rotation.NONE)
            elif driving_direction == Direction.EAST:
                return self._driving_curve(self._corner_east_north, Rotation.NONE)
            else:
                return self._sentinel
        if object_tile.rotation == Rotation.COUNTER_CLOCKWISE:  # top-right
            if driving_direction == Direction.SOUTH:
                return self._driving_curve(self._corner_east_north, Rotation.CLOCKWISE)
            elif driving_direction == Direction.WEST:
                return self._driving_curve(self._corner_south_west, Rotation.CLOCKWISE)
            else:
                return self._sentinel

    # Rail crosses rail
    if Global.Registry.RAIL_CROSSING.equals_ignore_rotation(object_tile):
        # Just steam straight ahead in the current direction
        if driving_direction == Direction.NORTH:
            return self._driving_curve(self._straight_line, Rotation.NONE)
        elif driving_direction == Direction.EAST:
            return self._driving_curve(self._straight_line, Rotation.CLOCKWISE)
        elif driving_direction == Direction.SOUTH:
            return self._driving_curve(self._straight_line, Rotation.HALF)
        else:
            return self._driving_curve(self._straight_line, Rotation.COUNTER_CLOCKWISE)
    return self._sentinel

# Returns the position where the next rail would be expected after this rail.
# Returns the input input_tile_pos if there is no rail there.
func get_next_rail(input_tile_pos: Vector2, driving_direction: int) -> Vector2:
    var result = self._objects.get_tile_and_coords(int(input_tile_pos.x), int(input_tile_pos.y))
    var tile_x = result[0]
    var tile_y = result[1]
    var object_tile: ObjectTile = result[2]

    # Standard rails
    if Global.Registry.RAIL_STRAIGHT.equals_ignore_rotation(object_tile) \
        or Global.Registry.RAIL_WITHOUT_SLEEPERS.equals_ignore_rotation(object_tile):
        if object_tile.rotation == Rotation.NONE or object_tile.rotation == Rotation.HALF:
            if driving_direction == Direction.NORTH:
                return Vector2(tile_x, tile_y - 1)
            elif driving_direction == Direction.SOUTH:
                return Vector2(tile_x, tile_y + 1)
            else:
                return input_tile_pos  # Cannot approach a vertical rail from this direction
        elif object_tile.rotation == Rotation.CLOCKWISE or object_tile.rotation == Rotation.COUNTER_CLOCKWISE:
            if driving_direction == Direction.EAST:
                return Vector2(tile_x + 1, tile_y)
            elif driving_direction == Direction.WEST:
                return Vector2(tile_x - 1, tile_y)
            else:
                return input_tile_pos  # Cannot approach a horizontal rail from this direction

    # Rail crosses road
    if Global.Registry.RAIL_CROSSING_ROAD.equals_ignore_rotation(object_tile):
        # (rotation is different than for normal rails, as the rotation is from
        #  the perspective of the road)
        if object_tile.rotation == Rotation.CLOCKWISE or object_tile.rotation == Rotation.COUNTER_CLOCKWISE:
            if driving_direction == Direction.NORTH:
                return Vector2(tile_x, tile_y - 2)
            elif driving_direction == Direction.SOUTH:
                return Vector2(tile_x, tile_y + 2)
            else:
                return input_tile_pos  # Cannot approach a vertical rail from this direction
        elif object_tile.rotation == Rotation.NONE or object_tile.rotation == Rotation.HALF:
            if driving_direction == Direction.EAST:
                return Vector2(tile_x + 2, tile_y)
            elif driving_direction == Direction.WEST:
                return Vector2(tile_x - 2, tile_y)
            else:
                return input_tile_pos  # Cannot approach a horizontal rail from this direction

    # Corner-case
    if Global.Registry.RAIL_CORNER.equals_ignore_rotation(object_tile):
        if object_tile.rotation == Rotation.NONE:  # bottom-right
            if driving_direction == Direction.NORTH:
                return Vector2(tile_x + 2, tile_y - 1)
            elif driving_direction == Direction.WEST:
                return Vector2(tile_x - 1, tile_y + 2)
            else:
                return input_tile_pos
        if object_tile.rotation == Rotation.CLOCKWISE:  # left-bottom
            if driving_direction == Direction.NORTH:
                return Vector2(tile_x - 2, tile_y - 1)
            elif driving_direction == Direction.EAST:
                return Vector2(tile_x + 1, tile_y + 2)
            else:
                return input_tile_pos
        if object_tile.rotation == Rotation.HALF:  # top-left
            if driving_direction == Direction.SOUTH:
                return Vector2(tile_x - 2, tile_y + 1)
            elif driving_direction == Direction.EAST:
                return Vector2(tile_x + 1, tile_y - 2)
            else:
                return input_tile_pos
        if object_tile.rotation == Rotation.COUNTER_CLOCKWISE:  # top-right
            if driving_direction == Direction.SOUTH:
                return Vector2(tile_x + 2, tile_y + 1)
            elif driving_direction == Direction.WEST:
                return Vector2(tile_x - 1, tile_y - 2)
            else:
                return input_tile_pos

    # Rail crosses rail
    if Global.Registry.RAIL_CROSSING.equals_ignore_rotation(object_tile):
        # Just steam straight ahead in the current direction
        return Vector2(tile_x, tile_y) + Direction.to_vector(driving_direction)

    return input_tile_pos  # Not a rail

# Gets the tile coordinate from the given world coordinate.
func to_tile_pos(position: Vector2) -> Vector2:
    return self._objects.world_to_map(position)

# Gets the world coordinate from the given tile coordinate.
func to_world_pos(tile_pos: Vector2) -> Vector2:
    return self._objects.map_to_world(tile_pos)
