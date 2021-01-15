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
    if tile.equals_ignore_rotation(Global.Registry.EMPTY):
        # Removing a tile - special case the layer
        var entity_tiles = get_tile_map(ObjectType.ENTITY)
        if entity_tiles.get_tile(tile_pos).equals_ignore_rotation(Global.Registry.EMPTY):
            # Nothing on entity layer, delete on surface layer
            get_tile_map(ObjectType.SURFACE).set_tile(tile_pos, tile, overwrite)
        else:
            # Delete on entity layer
            entity_tiles.set_tile(tile_pos, tile, overwrite)
        return
    
    # Normale placement
    var object_type = tile.get_type()
    get_tile_map(object_type).set_tile(tile_pos, tile, overwrite)

func get_tile(tile_pos: Vector2, object_type: int) -> ObjectTile:
    return self.get_tile_map(object_type).get_tile(tile_pos)

# Low-level method to change a tile.
func set_raw_texture(object_type: int, tile_x: int, tile_y: int, texture_id: int) -> void:
    self.get_tile_map(object_type).set_cell(tile_x, tile_y, texture_id)

# Gets the tile coordinate from the given mouse event
func mouse_event_to_tile_pos(mouse: InputEvent) -> Vector2:
    return self._surface.mouse_event_to_tile_pos(mouse)

# Gets the tile coordinate from the given viewport coordinate
func viewport_pos_to_tile_pos(position: Vector2) -> Vector2:
    return self._surface.viewport_pos_to_tile_pos(position)

func local_pos_to_tile_pos(position: Vector2) -> Vector2:
    return self._surface.local_pos_to_tile_pos(position)

# Gets the tile map of the given kind.
func get_tile_map(object_type: int) -> ObjectsTileMap:
    if object_type == ObjectType.GROUND:
        return self._ground
    elif object_type == ObjectType.SURFACE:
        return self._surface
    elif object_type == ObjectType.ENTITY:
        return self._entities
    else:
        push_error("Unknown object type: " + str(object_type))
        return self._ground

func rotate_clockwise():
    $GroundTileMap.rotate_clockwise()
    $SurfaceTileMap.rotate_clockwise()
    $EntitiesTileMap.rotate_clockwise()
    for entity in $EntitiesTileMap.get_children():
        entity.rotate_clockwise()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
