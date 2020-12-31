# Class that reprents all walkable tiles in the world.
extends Reference
class_name PathsInWorld

var _surface: ObjectsTileMap
var _ground: ObjectsTileMap
var _world_tile_area: Rect2

func _init(world_tile_area: Rect2, surface: ObjectsTileMap, ground: ObjectsTileMap):
    self._surface = surface
    self._ground = ground
    self._world_tile_area = world_tile_area

# Gets whether the player can walk on the given tile position.
func can_walk_on(tile_pos: Vector2) -> bool:
    var ground_tile = self._ground.get_tile(tile_pos)
    var object_tile = self._surface.get_tile(tile_pos)

    if ground_tile.equals(Global.Registry.PATH_CONCRETE_GRAY) \
        or ground_tile.equals(Global.Registry.PATH_CONCRETE_YELLOW):
        # Walking on a plain path, check if no object is blocking it

        if object_tile.equals_ignore_rotation(Global.Registry.EMPTY):
            return true
        if object_tile.equals_ignore_rotation(Global.Registry.RAIL_WITHOUT_SLEEPERS):
            return true

    # Some objects can always be walked on, irregardless of the ground tile
    if object_tile.equals_ignore_rotation(Global.Registry.ROAD_CROSSING):
        return true

    return false

# Gets the tile coordinate from the given world coordinate.
func to_tile_pos(position: Vector2) -> Vector2:
    return self._ground.world_to_map(position)

# Gets the world coordinate from the given tile coordinate
func to_world_pos(tile_pos: Vector2) -> Vector2:
    return self._ground.map_to_world(tile_pos)

# Snaps the world position to the tile grid, so that you are aligned.
# Minimizes the movement, so if you are in the bottom right of one tile, you
# are moved to the top left of another tile.
func snap_to_grid(position: Vector2) -> Vector2:
    var closest_tile_x = round(position.x / self._ground.cell_size.x)
    var closest_tile_y = round(position.y / self._ground.cell_size.y)
    return to_world_pos(Vector2(closest_tile_x, closest_tile_y))

# Returns true if the movement from previous_position to position meant that the
# object was aligned somewhere in between.
func was_aligned(previous_position: Vector2, position: Vector2) -> bool:
    var aligned_position = self.snap_to_grid(previous_position)
    if previous_position.x < aligned_position.x and position.x >= aligned_position.x:
        return true
    if previous_position.x > aligned_position.x and position.x <= aligned_position.x:
        return true
    if previous_position.y < aligned_position.y and position.y >= aligned_position.y:
        return true
    if previous_position.y > aligned_position.y and position.y <= aligned_position.y:
        return true
    return false

