class_name FileIO

const _META_SUFFIX = ".meta.txt"

# File format: Dictionary with the following values
# "registry": Array, mapping numeric ids to strings.
# "saved_area": Rect2, the world size in tile coords.
# "ground_ids": PoolByteArray, ids of ground, rows first. The length of this array depends on the world size.
# "object_ids": PoolIntArray, ids of objects, rows first. The length of this array depends on the world size.

# Reads a safe file. Returns OK or ERR_DOES_NOT_EXIST
static func load_world(file_name: String, objects: ObjectsTileMap, ground: GroundTileMap) -> int:
    print("Loading " + file_name)
    var file_handle = File.new()
    if not file_handle.file_exists(file_name):
        return ERR_DOES_NOT_EXIST
    var open_result = file_handle.open(file_name, File.READ)
    if open_result != OK:
        push_error("Failed to open " + file_name + " for reading. Error " + str(open_result))
        return ERR_FILE_CANT_READ
    var dictionary = file_handle.get_var(false)
    if not dictionary is Dictionary:
        push_error("Failed to load: " + file_name + " does not contain a dictionary")
        return ERR_FILE_CORRUPT
    # Check types
    if not dictionary.get("registry") is Array\
         or not dictionary.get("saved_area") is Rect2\
         or not dictionary.get("ground_ids") is PoolByteArray\
         or not dictionary.get("object_ids") is PoolIntArray:
         push_error("Failed to load: " + file_name + " failed a type check")
         return ERR_FILE_CORRUPT
    var registry : Array = _create_index_to_texture_id_map(dictionary["registry"])
    var saved_area : Rect2 = dictionary["saved_area"]
    var ground_ids : PoolByteArray = dictionary["ground_ids"]
    var object_ids : PoolIntArray = dictionary["object_ids"]
    var x = saved_area.position.x
    if ground_ids.size() < saved_area.get_area() or object_ids.size() < saved_area.get_area():
        push_error("Failed to load: " + file_name + " has not enough entries")
        return ERR_FILE_CORRUPT
    var i = 0
    while x < saved_area.end.x:
        var y = saved_area.position.y
        while y < saved_area.end.y:
            objects.set_cell(x, y, registry[object_ids[i]])
            ground.set_cell(x, y, registry[ground_ids[i]])
            i += 1
            y += 1
        x += 1

    return OK


# Starts with a index => name map, converts to an index => texture id map. In this
# way, loading is very fast, as we can directly map one number to another number.
static func _create_index_to_texture_id_map(id_to_key: Array) -> PoolIntArray:
    var output = PoolIntArray()
    for key in id_to_key:
        var tile = Global.Registry.get_tile_by_name(key)
        if tile is GroundTile:
            output.append(tile.texture_id)
        elif tile is ObjectTile:
            output.append(tile.get_texture_id())
        else:
            output.append(-1)
    return output


# Creates the parent directories for the given file name. So for the file "user://Resources/Images/player.png",
# the directory "user://Resources/Images" is created, along with its parent directory.
static func _create_parent_directories(file_name: String) -> bool:
    var directory_name = file_name.get_base_dir()
    var directory_handle = Directory.new()
    if not directory_handle.dir_exists(directory_name):
        var result = directory_handle.make_dir_recursive(directory_name)
        if result != OK:
            push_error("Failed to make parent directories. Error " + str(result))
            return false
    return true


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
            var world_file_path = file_path.substr(0, file_path.length() - _META_SUFFIX.length())
            var file_handle = File.new()
            file_handle.open(file_path, File.READ)
            var world_name = file_handle.get_line()
            return_value[world_file_path] = world_name

    directory.list_dir_end()
    return return_value


# Writes all data of the level to the given file. Returns ERR_FILE_BAD_PATH
# if the parent directory does not exist and could not be created. Returns
# ERR_FILE_CANT_WRITE if writing fails. Returns OK on succes.
static func write(file_name: String, save_area: Rect2, objects: ObjectsTileMap, ground: GroundTileMap) -> int:
    if not _create_parent_directories(file_name):
        return ERR_FILE_BAD_PATH
    var id_registry = _IdRegistry.new()

    var object_ids = PoolIntArray()
    var ground_ids = PoolByteArray()
    var x = save_area.position.x
    while x < save_area.end.x:
        var y = save_area.position.y
        while y < save_area.end.y:
            var tile_pos = Vector2(x, y)
            var object_tile = objects.get_tile_no_search(x, y)
            var ground_tile = ground.get_tile(tile_pos)
            var object_key = object_tile.to_string()
            object_ids.append(id_registry.get_or_assign_id(object_key))
            ground_ids.append(id_registry.get_or_assign_id(ground_tile.name_id))
            y += 1
        x += 1

    # Write the file
    var file = File.new()
    var open_result = file.open(file_name, File.WRITE)
    if open_result != OK:
        push_error("Failed to open save file. Error " + str(open_result))
        return ERR_FILE_CANT_WRITE
    file.store_var({
        "registry": id_registry.get_id_to_key_array(),
        "saved_area": save_area,
        "ground_ids": ground_ids,
        "object_ids": object_ids
    })
    file.close()
    return OK

# Writes the world name to a file next to the world file. Returns ERR_FILE_BAD_PATH
# if the parent directory does not exist and could not be created. Returns
# ERR_FILE_CANT_WRITE if writing fails. Returns OK on succes.
static func write_name(world_file_name: String, world_name: String) -> int:
    if not _create_parent_directories(world_file_name):
        return ERR_FILE_BAD_PATH
    var name_file = File.new()
    var open_result = name_file.open(world_file_name + _META_SUFFIX, File.WRITE)
    if open_result != OK:
        push_error("Failed to open world name file. Error " + str(open_result))
        return ERR_FILE_CANT_WRITE
    name_file.store_line(world_name)
    name_file.close()
    return OK


# Deletes a world and its meta file. Returns ERR_FILE_NOT_FOUND if the world doesn't exist,
# returns FAILED if the world does exist but the file couldn't be removed and returns OK if
# deletion succeeded.
static func delete_world(world_file_name: String) -> int:
    var file_handle = File.new()
    var directory_handle = Directory.new()
    if not file_handle.file_exists(world_file_name):
        return ERR_FILE_NOT_FOUND
    if file_handle.file_exists(world_file_name + _META_SUFFIX):
        var result = directory_handle.remove(world_file_name + _META_SUFFIX)
        if result != OK:
            push_error("Failed to delete meta file " + world_file_name + _META_SUFFIX + ". Error " + str(result))
            return FAILED
    var result = directory_handle.remove(world_file_name)
    if result != OK:
        push_error("Failed to delete file " + world_file_name + ". Error " + str(result))
        return FAILED
    return OK


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

