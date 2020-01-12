const ObjectTile = preload("res://Scripts/ObjectTile.gd")
const GroundTile = preload("res://Scripts/GroundTile.gd")

var _texture_id_to_object_tile := {}
var _texture_id_to_ground_tile := {}


# Registers an object tile from the Objects tile set, so that it can be found using get_object_tile_from_*
func _register_object_tile_with_auto_rotation(tile: ObjectTile) -> ObjectTile:
    for rotated_tile in tile.all_rotations():
        _texture_id_to_object_tile[rotated_tile.get_texture_id()] = rotated_tile
    
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
var OBJECT_EMPTY := _register_object_tile_with_auto_rotation(ObjectTile.new("object_empty", [-1, -1, -1, -1]))
#warning-ignore:unused_class_variable
var RAIL_STRAIGHT := _register_object_tile_with_auto_rotation(ObjectTile.new("rail_straight", [0, 16, 0, 16]))
#warning-ignore:unused_class_variable
var RAIL_CORNER := _register_object_tile_with_auto_rotation(ObjectTile.new("rail_corner", [1, 13, 14, 15]))
#warning-ignore:unused_class_variable
var ROAD_STRAIGHT := _register_object_tile_with_auto_rotation(ObjectTile.new("road_straight", [4, 3, 4, 3]))
#warning-ignore:unused_class_variable
var ROAD_CORNER := _register_object_tile_with_auto_rotation(ObjectTile.new("road_corner", [7, 9, 11, 12]))
#warning-ignore:unused_class_variable
var ROAD_CROSSING := _register_object_tile_with_auto_rotation(ObjectTile.new("road_crossing", [2, 2, 2, 2]))
#warning-ignore:unused_class_variable
var ROAD_T := _register_object_tile_with_auto_rotation(ObjectTile.new("road_t", [5, 6, 8, 10]))

# Ground tiles
var GRASS := _register_ground_tile(GroundTile.new("grass", 0))
#warning-ignore:unused_class_variable
var SAND := _register_ground_tile(GroundTile.new("sand", 1))
#warning-ignore:unused_class_variable
var GRAVEL := _register_ground_tile(GroundTile.new("gravel", 2))
#warning-ignore:unused_class_variable
var SNOW := _register_ground_tile(GroundTile.new("snow", 3))
#warning-ignore:unused_class_variable
var DIRT := _register_ground_tile(GroundTile.new("dirt", 4))
#warning-ignore:unused_class_variable
var WATER := _register_ground_tile(GroundTile.new("water", 5))

