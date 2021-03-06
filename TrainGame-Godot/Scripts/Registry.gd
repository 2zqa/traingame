extends Reference

var _texture_id_to_object_tile := {}
var _texture_id_to_ground_tile := {}
var _name_to_tile := {}

# Registers an object tile from the Objects tile set, so that it can be found using get_object_tile_from_*
func _register_object_tile(tile: ObjectTile) -> ObjectTile:
    for rotated_tile in tile.all_rotations():
        var texture_id = rotated_tile.get_texture_id()
        if not _texture_id_to_object_tile.has(texture_id):
            # Don't overwrite existing texture ids in the map.
            # In this way, if multiple rotations share the same texture, the first rotation (Rotation.NONE) wins.
            _texture_id_to_object_tile[texture_id] = rotated_tile
        _name_to_tile[rotated_tile.to_string()] = rotated_tile

    return tile


# Creates a object tile for the given ground
func _register_ground_tile(name: String, texture_id: int) -> ObjectTile:
    var tile = ObjectTile.new(name, ObjectType.GROUND, {
        texture_ids=[texture_id, texture_id, texture_id, texture_id]
    })
    _register_object_tile(tile)
    return tile


# Gets the object tile from the given texture id, or OBJECT_EMPTY if not found.
func get_object_tile_from_texture_id(texture_id: int) -> ObjectTile:
    var object_tile = _texture_id_to_object_tile.get(texture_id)
    if object_tile == null:
        return EMPTY
    return object_tile


# Gets the tile with the given name, or null if none exists.
func get_tile_by_name(name: String) -> ObjectTile:
    return self._name_to_tile.get(name)


# The EMPTY tile (ObjectType is not correct here)
var EMPTY := ObjectTile.new("empty", ObjectType.GROUND, {texture_ids=[-1, -1, -1, -1]})

# Surface tiles
#warning-ignore:unused_class_variable
var RAIL_STRAIGHT := _register_object_tile(ObjectTile.new("rail_straight", ObjectType.SURFACE, {
    texture_ids=[0, 16, 0, 16], 
    rail=Rails.short_vertical_rail()}))
#warning-ignore:unused_class_variable
var RAIL_CORNER := _register_object_tile(ObjectTile.new("rail_corner", ObjectType.SURFACE, {
    texture_ids=[1, 14, 15, 13],
    shape="XXX\nXOX\nXX.",
    rail=Rails.corner_rail()}))
#warning-ignore:unused_class_variable
var RAIL_SWITCH_1 := _register_object_tile(ObjectTile.new("rail_switch_1", ObjectType.SURFACE, {texture_ids=[42, 44, 49, 48], shape="XXX\nXOX\nXX."}))
#warning-ignore:unused_class_variable
var RAIL_SWITCH_2 := _register_object_tile(ObjectTile.new("rail_switch_2", ObjectType.SURFACE, {texture_ids=[46, 47, 45, 43], shape="XXX\nXOX\nXX."}))
#warning-ignore:unused_class_variable
var RAIL_CROSSING := _register_object_tile(ObjectTile.new("rail_crossing", ObjectType.SURFACE, {
    texture_ids=[41, 41, 41, 41],
    rail=Rails.crossing_rail()}))
#warning-ignore:unused_class_variable
var RAIL_CROSSING_CONCRETE_GRAY := _register_object_tile(ObjectTile.new("rail_crossing_concrete_gray", ObjectType.SURFACE, {
    texture_ids=[51, 52, 51, 52],
    rail=Rails.short_vertical_rail()}))
#warning-ignore:unused_class_variable
var RAIL_CROSSING_CONCRETE_YELLOW := _register_object_tile(ObjectTile.new("rail_crossing_concrete_yellow", ObjectType.SURFACE, {
    texture_ids=[65, 66, 65, 66],
    rail=Rails.short_vertical_rail()}))
#warning-ignore:unused_class_variable
var ROAD_STRAIGHT := _register_object_tile(ObjectTile.new("road_straight", ObjectType.SURFACE, {texture_ids=[4, 3, 4, 3], shape="XOX"}))
#warning-ignore:unused_class_variable
var ROAD_CORNER := _register_object_tile(ObjectTile.new("road_corner", ObjectType.SURFACE, {texture_ids=[7, 11, 9, 12], shape="XXX\nXOX\nXXX"}))
#warning-ignore:unused_class_variable
var ROAD_INTERSECTION := _register_object_tile(ObjectTile.new("road_intersection", ObjectType.SURFACE, {texture_ids=[2, 2, 2, 2], shape="XXX\nXOX\nXXX"}))
#warning-ignore:unused_class_variable
var ROAD_T := _register_object_tile(ObjectTile.new("road_t", ObjectType.SURFACE, {texture_ids=[5, 10, 6, 8], shape="XXX\nXOX\nXXX"}))
#warning-ignore:unused_class_variable
var RAIL_CROSSING_ROAD := _register_object_tile(ObjectTile.new("rail_crossing_road", ObjectType.SURFACE, {
    texture_ids=[36, 35, 36, 35], 
    shape="XOX",
    rail=Rails.rotate(Rails.long_vertical_rail(), Rotation.CLOCKWISE)}))
#warning-ignore:unused_class_variable
var ROAD_CROSSING := _register_object_tile(ObjectTile.new("road_crossing", ObjectType.SURFACE, {texture_ids=[54, 53, 54, 53], shape="XOX"}))

#warning-ignore:unused_class_variable
var PATH_CONCRETE_GRAY := _register_object_tile(ObjectTile.new("path_concrete_gray", ObjectType.SURFACE, {texture_ids=[63, 63, 63, 63]}))
#warning-ignore:unused_class_variable
var PATH_CONCRETE_YELLOW := _register_object_tile(ObjectTile.new("path_concrete_yellow", ObjectType.SURFACE, {texture_ids=[64, 64, 64, 64]}))



#warning-ignore:unused_class_variable
var TREE_SMALL := _register_object_tile(ObjectTile.new("tree_small", ObjectType.ENTITY, {texture_ids=[28, 28, 28, 28]}))
#warning-ignore:unused_class_variable
var TREE := _register_object_tile(ObjectTile.new("tree", ObjectType.ENTITY, {texture_ids=[21, 21, 21, 21]}))
#warning-ignore:unused_class_variable
var TREE_CITY := _register_object_tile(ObjectTile.new("tree_city", ObjectType.ENTITY, {texture_ids=[22, 22, 22, 22]}))
#warning-ignore:unused_class_variable
var TREE_LARGE := _register_object_tile(ObjectTile.new("tree_large", ObjectType.ENTITY, {texture_ids=[17, 17, 17, 17]}))
#warning-ignore:unused_class_variable
var TREE_CITY_LARGE := _register_object_tile(ObjectTile.new("tree_city_large", ObjectType.ENTITY, {texture_ids=[18, 18, 18, 18]}))
#warning-ignore:unused_class_variable
var TREE_GROUP := _register_object_tile(ObjectTile.new("tree_group", ObjectType.ENTITY, {texture_ids=[25, 25, 25, 25], shape="XX\ndX"}))

#warning-ignore:unused_class_variable
var TREE_AUTUMN_SMALL := _register_object_tile(ObjectTile.new("tree_autumn_small", ObjectType.ENTITY, {texture_ids=[24, 24, 24, 24]}))
#warning-ignore:unused_class_variable
var TREE_AUTUMN := _register_object_tile(ObjectTile.new("tree_autumn", ObjectType.ENTITY, {texture_ids=[23, 23, 23, 23]}))
#warning-ignore:unused_class_variable
var TREE_AUTUMN_CITY := _register_object_tile(ObjectTile.new("tree_autumn_city", ObjectType.ENTITY, {texture_ids=[32, 32, 32, 32]}))
#warning-ignore:unused_class_variable
var TREE_AUTUMN_LARGE := _register_object_tile(ObjectTile.new("tree_autumn_large", ObjectType.ENTITY, {texture_ids=[19, 19, 19, 19]}))
#warning-ignore:unused_class_variable
var TREE_AUTUMN_CITY_LARGE := _register_object_tile(ObjectTile.new("tree_autumn_city_large", ObjectType.ENTITY, {texture_ids=[31, 31, 31, 31]}))
#warning-ignore:unused_class_variable
var TREE_AUTUMN_GROUP := _register_object_tile(ObjectTile.new("tree_autumn_group", ObjectType.ENTITY, {texture_ids=[26, 26, 26, 26], shape="XX\ndX"}))

#warning-ignore:unused_class_variable
var BUILDING_BANK := _register_object_tile(ObjectTile.new("building_bank", ObjectType.ENTITY, {texture_ids=[37, 39, 40, 38], shape="XXXXX\nXX^XX"}))
#warning-ignore:unused_class_variable
var BUILDING_SIMPLE := _register_object_tile(ObjectTile.new("building_simple", ObjectType.ENTITY, {texture_ids=[55, 56, 55, 56], shape="XX\ndX"}))
#warning-ignore:unused_class_variable
var BUILDING_TRAIN_SHED := _register_object_tile(ObjectTile.new("building_train_shed", ObjectType.ENTITY, {texture_ids=[67, 68, 67, 68], shape="XXXXX\nXXOXX\nXXXXX"}))

# Ground tiles
var GRASS := _register_ground_tile("grass", 59)
#warning-ignore:unused_class_variable
var SAND := _register_ground_tile("sand", 57)
#warning-ignore:unused_class_variable
var GRAVEL := _register_ground_tile("gravel", 58)
#warning-ignore:unused_class_variable
var SNOW := _register_ground_tile("snow", 60)
#warning-ignore:unused_class_variable
var DIRT := _register_ground_tile("dirt", 61)
#warning-ignore:unused_class_variable
var WATER := _register_ground_tile("water", 62)
