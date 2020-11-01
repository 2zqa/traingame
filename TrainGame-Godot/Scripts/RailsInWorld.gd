# Class that represents all the rails in the world.
extends Reference
class_name RailsInWorld

const _RAIL_STRAIGHT = 1
const _RAIL_CORNER = 2

var _rail_paths := Dictionary()
var _objects: ObjectsTileMap

func _init(objects: ObjectsTileMap):
    self._objects = objects

# Gets the rail position X px away from the current position. Use amount=0 to
# get only an aligned position.
func add_to_position(position: Vector2, direction: int, amount: float) -> Vector2:
    var tile_pos_train = self._objects.viewport_pos_to_tile_pos(position)
    var tile_and_coords = self._objects.get_tile_and_coords(int(tile_pos_train.x), int(tile_pos_train.y))

    var rail_tile: ObjectTile = tile_and_coords[2]
    var rail_pos_in_viewport = self._objects.tile_pos_to_viewport_pos(Vector2(tile_and_coords[0], tile_and_coords[1]))
    var position_relative_to_rail = position - rail_pos_in_viewport
    var rail: Rails.RailPathSegment = rail_tile.get_rail()

    var movement_result = rail.get_increased_position(position_relative_to_rail, direction, amount)
    var new_position = movement_result[0] + rail_pos_in_viewport
    var new_direction = movement_result[1]
    var new_amount = movement_result[2]
    if new_amount > 0:
        # Recurse, not yet done
        return add_to_position(new_position, new_direction, new_amount)
    return new_position

# Gets the updated direciton, based on relative movement. Direction will remain unchanged if no movement occurs.
func to_updated_direction(old_direction: int, old_position: Vector2, new_position: Vector2):
    if old_direction == Direction.EAST or old_direction == Direction.WEST:
        if new_position.y < old_position.y:
            return Direction.NORTH
        elif new_position.y > old_position.y:
            return Direction.SOUTH
    elif old_direction == Direction.NORTH or old_direction == Direction.SOUTH:
        if new_position.x < old_position.x:
            return Direction.WEST
        elif new_position.x > old_position.x:
            return Direction.EAST
    return old_direction

# Gets the tile coordinate from the given world coordinate.
func to_tile_pos(position: Vector2) -> Vector2:
    return self._objects.world_to_map(position)

# Gets the world coordinate from the given tile coordinate.
func to_world_pos(tile_pos: Vector2) -> Vector2:
    return self._objects.map_to_world(tile_pos)

# Snaps the position to one corner of the grid.
func snap_world_pos(position: Vector2) -> Vector2:
    return to_world_pos(to_tile_pos(position))
