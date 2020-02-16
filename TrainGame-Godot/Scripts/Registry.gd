const ObjectTile = preload("res://Scripts/ObjectTile.gd")
const GroundTile = preload("res://Scripts/GroundTile.gd")
const TileCollision = preload("res://Scripts/TileCollision.gd")


var _texture_id_to_object_tile := {}
var _texture_id_to_ground_tile := {}
var _name_to_tile := {}

# Registers an object tile from the Objects tile set, so that it can be found using get_object_tile_from_*
func _register_object_tile(tile: ObjectTile) -> ObjectTile:
    for rotated_tile in tile.all_rotations():
        var texture_id = rotated_tile.get_texture_id()
        if not _texture_id_to_ground_tile.has(texture_id):
            # Don't overwrite existing texture ids in the map.
            # In this way, if multiple rotations share the same texture, the first rotation (Rotation.NONE) wins.
            _texture_id_to_object_tile[texture_id] = rotated_tile
        _name_to_tile[rotated_tile.to_string()] = rotated_tile

    return tile


# Registers a ground tile from the Objects tile set, so that it can be found using get_object_tile_from_*
func _register_ground_tile(tile: GroundTile) -> GroundTile:
    _texture_id_to_ground_tile[tile.texture_id] = tile
    _name_to_tile[tile.to_string()] = tile
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


# Gets the tile with the given name, or null if none exists.
func get_tile_by_name(name: String) -> Object:
    return self._name_to_tile.get(name)


# Object tiles
var OBJECT_EMPTY := _register_object_tile(ObjectTile.new("object_empty", [-1, -1, -1, -1]))
#warning-ignore:unused_class_variable
var RAIL_STRAIGHT := _register_object_tile(ObjectTile.new("rail_straight", [0, 16, 0, 16]))
#warning-ignore:unused_class_variable
var RAIL_CORNER := _register_object_tile(ObjectTile.new("rail_corner", [1, 14, 15, 13], "XXX\nXOX\nXX."))
#warning-ignore:unused_class_variable
var RAIL_SWITCH_1 := _register_object_tile(ObjectTile.new("rail_switch_1", [42, 44, 49, 48], "XXX\nXOX\nXX."))
#warning-ignore:unused_class_variable
var RAIL_SWITCH_2 := _register_object_tile(ObjectTile.new("rail_switch_2", [46, 47, 45, 43], "XXX\nXOX\nXX."))
#warning-ignore:unused_class_variable
var RAIL_CROSSING := _register_object_tile(ObjectTile.new("rail_crossing", [41, 41, 41, 41]))
#warning-ignore:unused_class_variable
var ROAD_STRAIGHT := _register_object_tile(ObjectTile.new("road_straight", [4, 3, 4, 3], "XOX"))
#warning-ignore:unused_class_variable
var ROAD_CORNER := _register_object_tile(ObjectTile.new("road_corner", [7, 11, 9, 12], "XXX\nXOX\nXXX"))
#warning-ignore:unused_class_variable
var ROAD_INTERSECTION := _register_object_tile(ObjectTile.new("road_intersection", [2, 2, 2, 2], "XXX\nXOX\nXXX"))
#warning-ignore:unused_class_variable
var ROAD_T := _register_object_tile(ObjectTile.new("road_t", [5, 10, 6, 8], "XXX\nXOX\nXXX"))
#warning-ignore:unused_class_variable
var RAIL_CROSSING_ROAD := _register_object_tile(ObjectTile.new("rail_crossing_road", [36, 35, 36, 35], "XOX"))
#warning-ignore:unused_class_variable
var PATH_CONCRETE := _register_object_tile(ObjectTile.new("path_concrete", [50, 50, 50, 50]))
#warning-ignore:unused_class_variable
var RAIL_CROSSING_PATH_CONCRETE := _register_object_tile(ObjectTile.new("rail_crossing_path_concrete", [51, 52, 51, 52]))
#warning-ignore:unused_class_variable
var ROAD_CROSSING := _register_object_tile(ObjectTile.new("road_crossing", [54, 53, 54, 53], "XOX"))

#warning-ignore:unused_class_variable
var TREE_SMALL := _register_object_tile(ObjectTile.new("tree_small", [28, 28, 28, 28]))
#warning-ignore:unused_class_variable
var TREE := _register_object_tile(ObjectTile.new("tree", [21, 21, 21, 21]))
#warning-ignore:unused_class_variable
var TREE_CITY := _register_object_tile(ObjectTile.new("tree_city", [22, 22, 22, 22]))
#warning-ignore:unused_class_variable
var TREE_LARGE := _register_object_tile(ObjectTile.new("tree_large", [17, 17, 17, 17]))
#warning-ignore:unused_class_variable
var TREE_CITY_LARGE := _register_object_tile(ObjectTile.new("tree_city_large", [18, 18, 18, 18]))
#warning-ignore:unused_class_variable
var TREE_GROUP := _register_object_tile(ObjectTile.new("tree_group", [25, 25, 25, 25], "XX\ndX"))

#warning-ignore:unused_class_variable
var TREE_AUTUMN_SMALL := _register_object_tile(ObjectTile.new("tree_autumn_small", [24, 24, 24, 24]))
#warning-ignore:unused_class_variable
var TREE_AUTUMN := _register_object_tile(ObjectTile.new("tree_autumn", [23, 23, 23, 23]))
#warning-ignore:unused_class_variable
var TREE_AUTUMN_CITY := _register_object_tile(ObjectTile.new("tree_autumn_city", [32, 32, 32, 32]))
#warning-ignore:unused_class_variable
var TREE_AUTUMN_LARGE := _register_object_tile(ObjectTile.new("tree_autumn_large", [19, 19, 19, 19]))
#warning-ignore:unused_class_variable
var TREE_AUTUMN_CITY_LARGE := _register_object_tile(ObjectTile.new("tree_autumn_city_large", [31, 31, 31, 31]))
#warning-ignore:unused_class_variable
var TREE_AUTUMN_GROUP := _register_object_tile(ObjectTile.new("tree_autumn_group", [26, 26, 26, 26], "XX\ndX"))

var BUILDING_BANK := _register_object_tile(ObjectTile.new("building_bank", [37, 39, 40, 38], "XXXXX\nXX^XX"))

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

