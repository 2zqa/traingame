const ObjectTile = preload("res://Scripts/ObjectTile.gd")
const GroundTile = preload("res://Scripts/GroundTile.gd")

var _texture_id_to_object_tile := {}
var _texture_id_to_ground_tile := {}


# Registers an object tile from the Objects tile set, so that it can be found using get_object_tile_from_*
func _register_object_tile(tile: ObjectTile) -> ObjectTile:
    _texture_id_to_object_tile[tile.texture_id] = tile
    return tile


# Registers a ground tile from the Objects tile set, so that it can be found using get_object_tile_from_*
func _register_ground_tile(tile: GroundTile) -> GroundTile:
    _texture_id_to_ground_tile[tile.texture_id] = tile
    return tile


# Gets the object tile from the given texture id, or OBJECT_EMPTY if not found.
func get_object_tile_from_texture_id(texture_id: int) -> ObjectTile:
    var object_tile = _texture_id_to_object_tile.get(texture_id)
    if object_tile == null:
        return OBJECT_EMPTY
    return object_tile


# Gets the ground tile with the given texture id, or GRASS if not found.
func get_ground_tile_from_texture_id(texture_id: int) -> GroundTile:
    var ground_tile = _texture_id_to_ground_tile.get(texture_id)
    if ground_tile == null:
        return GRASS
    return ground_tile
    

# Object tiles
var OBJECT_EMPTY := _register_object_tile(ObjectTile.new("object_empty", -1))
var RAIL_STRAIGHT := _register_object_tile(ObjectTile.new("rail_straight", 0))
var RAIL_CORNER := _register_object_tile(ObjectTile.new("rail_corner", 1))

# Ground tiles
var GRASS := _register_ground_tile(GroundTile.new("grass", 0))
var SAND := _register_ground_tile(GroundTile.new("sand", 1))
var GRAVEL := _register_ground_tile(GroundTile.new("gravel", 2))
var SNOW := _register_ground_tile(GroundTile.new("snow", 3))
var DIRT := _register_ground_tile(GroundTile.new("dirt", 4))


