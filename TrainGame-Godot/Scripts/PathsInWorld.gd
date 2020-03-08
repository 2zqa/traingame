# Class that reprents all walkable tiles in the world.
class_name PathsInWorld

var _objects: ObjectsTileMap
var _ground: GroundTileMap
var _world_tile_area: Rect2

func _init(world_tile_area: Rect2, objects: ObjectsTileMap, ground: GroundTileMap):
    self._objects = objects
    self._ground = ground
    self._world_tile_area = world_tile_area

# Gets whether the player can walk on the given tile position.
func can_walk_on(tile_pos: Vector2) -> bool:
    var ground_tile = self._ground.get_tile(tile_pos)
    var object_tile = self._objects.get_tile(tile_pos)

    if ground_tile.equals(Global.Registry.PATH_CONCRETE_GRAY) \
        or ground_tile.equals(Global.Registry.PATH_CONCRETE_YELLOW):
        # Walking on a plain path, check if no object is blocking it

        if object_tile.equals_ignore_rotation(Global.Registry.OBJECT_EMPTY):
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

# Returns true if the given position (pixel coords) is aligned to a cell.
func is_aligned(position: Vector2) -> bool:
    return int(position.x) % int(self._ground.cell_size.x) == 0 \
        and int(position.y) % int(self._ground.cell_size.y) == 0
