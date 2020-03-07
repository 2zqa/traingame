# Class that reprents all walkable tiles in the world.
class_name PathsInWorld

var _objects: ObjectsTileMap
var _ground: GroundTileMap
var _world_tile_area: Rect2

func _init(objects: ObjectsTileMap, ground: GroundTileMap, world_tile_area: Rect2):
    self._objects = objects
    self._ground = ground
    self._world_tile_area = world_tile_area

func can_walk(tile_pos: Vector2) -> bool:
    var ground_tile = self._ground.get_tile(tile_pos)
    var object_tile = self._objects.get_tile(tile_pos)
    if object_tile.unrotated == Global.Registry.ROAD_CROSSING:
        return true
    return false

# Gets the tile coordinate from the given world coordinate.
func to_tile_pos(position: Vector2) -> Vector2:
    return self._ground.world_to_map(position)

# Returns true if the given position (pixel coords) is aligned to a cell.
func is_aligned(position: Vector2) -> bool:
    return int(position.x) % int(self._ground.cell_size.x) == 0 \
        and int(position.y) % int(self._ground.cell_size.y) == 0
