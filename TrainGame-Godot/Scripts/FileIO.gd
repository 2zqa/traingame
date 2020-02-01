class_name FileIO

# File format:
# Array, mapping numeric ids to strings.
# Rect2, the world size in tile coords.
# PoolByteArray, ids of ground, rows first. The length of this array depends on the world size.
# PoolIntArray, ids of objects, rows first. The length of this array depends on the world size.

static func read(file_name: String) -> void:
    pass

# Writes all data of the level to the given file.
static func write(file_name: String, save_area: Rect2, objects: ObjectsTileMap, ground: GroundTileMap) -> void:
    var id_registry = _IdRegistry.new()

    var object_ids = PoolIntArray()
    var ground_ids = PoolByteArray()
    var x = save_area.position.x
    while x < save_area.end.x:
        var y = save_area.position.y
        while y < save_area.position.y:
            var tile_pos = Vector2(x, y)
            var object_tile = objects.get_tile_no_search(x, y)
            var ground_tile = ground.get_tile(tile_pos)
            var object_key = object_tile.name_id + "." + str(object_tile.rotation)
            object_ids.append(id_registry.get_or_assign_id(object_key))
            ground_ids.append(id_registry.get_or_assign_id(ground_tile.name_id))
            y += 1
        x += 1

    # Write the file
    var file = File.new()
    file.open(file_name, File.WRITE) 
    file.store_var({
        "registry": id_registry.get_id_to_key_array(),
        "ground_ids": ground_ids,
        "object_ids": object_ids
    })
    file.close()


# Used to keep track of id <==> key mappings. Ids are auto-incremented ints, keys are strings.
class _IdRegistry:
    var _key_to_id: Dictionary
    var _id_to_key: Array

    func _init():
        self._key_to_id = Dictionary()
        self._id_to_key = Array()

    # Gets the id of the given object, or assings an id if no id exists yet.
    func get_or_assign_id(key: String) -> int:
        var id = self._key_to_id.get(key)
        if id == null:
            id = self._id_to_key.size()
            self._id_to_key.append(key)
            self._key_to_id[key] = id
        return id

    # Gets the id -> key mapping.
    func get_id_to_key_array() -> Array:
        return self._id_to_key
