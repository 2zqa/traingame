class_name FileIO

const _META_SUFFIX = ".meta.txt"

# File format: Dictionary with the following values
# "registry": Array, mapping numeric ids to strings.
# "saved_area": Rect2, the world size in tile coords.
# "ground_ids": PoolByteArray, ids of ground, rows first. The length of this array depends on the world size.
# "object_ids": PoolIntArray, ids of objects, rows first. The length of this array depends on the world size.

static func read(file_name: String) -> void:
    pass

# Creates the parent directories for the given file name. So for the file "user://Resources/Images/player.png",
# the directory "user://Resources/Images" is created, along with its parent directory.
static func _create_parent_directories(file_name: String) -> void:
    var directory_name = file_name.get_base_dir()
    var directory_handle = Directory.new()
    if not directory_handle.dir_exists(directory_name):
        directory_handle.make_dir_recursive(directory_name)


# Gets a dictionary file name => world name of all worlds in the given directory.
static func read_world_names(directory_name: String) -> Dictionary:
    var directory = Directory.new()
    if directory.open(directory_name) != OK:
        return directory  # Directory doesn't exist
    directory.list_dir_begin(true)

    var return_value = Dictionary()
    while true:
        var file_name = directory.get_next()
        if file_name == "":
            break
        elif file_name.ends_with(_META_SUFFIX):
            var file_path = directory_name + "/" + file_name
            var world_file_path = file_path.substr(file_name.length() - _META_SUFFIX.length(), _META_SUFFIX.length())
            var file_handle = File.new()
            file_handle.open(file_path, File.READ)
            var world_name = file_handle.get_line()
            return_value[world_file_path] = world_name

    directory.list_dir_end()
    return return_value


# Writes all data of the level to the given file.
static func write(file_name: String, save_area: Rect2, objects: ObjectsTileMap, ground: GroundTileMap) -> void:
    _create_parent_directories(file_name)
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
    var open_result = file.open(file_name, File.WRITE)
    if open_result != OK:
        push_error("Failed to open save file. Error " + str(open_result))
    file.store_var({
        "registry": id_registry.get_id_to_key_array(),
        "saved_area": save_area,
        "ground_ids": ground_ids,
        "object_ids": object_ids
    })
    file.close()
    print("Saved to " + file_name)

# Writes the world name to a file next to the world file
static func write_name(world_file_name: String, world_name: String) -> void:
    _create_parent_directories(world_file_name)
    var name_file = File.new()
    var open_result = name_file.open(world_file_name + _META_SUFFIX, File.WRITE)
    if open_result != OK:
        push_error("Failed to open world name file. Error " + str(open_result))
    name_file.store_line(world_name)
    name_file.close()


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
