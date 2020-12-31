extends Node2D
class_name GameWorld

const WORLD_RECTANGLE := Rect2(Vector2(-100, -100), Vector2(201, 201))

var _ground: ObjectsTileMap
var _surface: ObjectsTileMap
var _entities: ObjectsTileMap

# Called when the node enters the scene tree for the first time.
func _ready():
    self._ground = $GroundTileMap
    self._surface = $SurfaceTileMap
    self._entities = $EntitiesTileMap

func set_tile(tile_pos: Vector2, tile: ObjectTile, overwrite: bool = true) -> void:
    var object_type = tile.get_type()
    if object_type == ObjectType.GROUND:
        self._ground.set_tile(tile_pos, tile, overwrite)
    elif object_type == ObjectType.SURFACE:
        self._surface.set_tile(tile_pos, tile, overwrite)
    elif object_type == ObjectType.ENTITY:
        self._entities.set_tile(tile_pos, tile, overwrite)
    else:
        push_error("Unknown object type in: " + str(tile))

func get_tile(tile_pos: Vector2, object_type: int) -> ObjectTile:
    if object_type == ObjectType.GROUND:
        return self._ground.get_tile(tile_pos)
    elif object_type == ObjectType.SURFACE:
        return self._surface.get_tile(tile_pos)
    elif object_type == ObjectType.ENTITY:
        return self._entities.get_tile(tile_pos)
    else:
        push_error("Unknown object type: " + str(object_type))
        return self._ground.get_tile(tile_pos)

# Low-level method to change a tile.
func set_raw_texture(object_type: int, tile_x: int, tile_y: int, texture_id: int) -> void:
    if object_type == ObjectType.GROUND:
        self._ground.set_cell(tile_x, tile_y, texture_id)
    elif object_type == ObjectType.SURFACE:
        self._surface.set_cell(tile_x, tile_y, texture_id)
    elif object_type == ObjectType.ENTITY:
        self._entities.set_cell(tile_x, tile_y, texture_id)
    else:
        push_error("Unknown object type: " + str(object_type))

# Gets the tile coordinate from the given mouse event
func mouse_event_to_tile_pos(mouse: InputEvent) -> Vector2:
    return self._surface.mouse_event_to_tile_pos(mouse)

# Gets the tile coordinate from the given viewport coordinate
func viewport_pos_to_tile_pos(position: Vector2) -> Vector2:
    return self._surface.viewport_pos_to_tile_pos(position)

func local_pos_to_tile_pos(position: Vector2) -> Vector2:
    return self._surface.local_pos_to_tile_pos(position)

func rotate_clockwise():
    $GroundTileMap.rotate_clockwise()
    $SurfaceTileMap.rotate_clockwise()
    $EntitiesTileMap.rotate_clockwise()
    for entity in $EntitiesTileMap.get_children():
        entity.rotate_clockwise()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
