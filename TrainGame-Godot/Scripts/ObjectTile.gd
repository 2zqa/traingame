extends Reference
class_name ObjectTile

const _TILE_SET := preload("res://TileSets/Objects.tres")

var name_id: String
var rotation: int
var _texture_ids: Array
var _shape: TileCollision
var _rail: Rails.RailPathSegment

# Creates a new instance. Dictionary parameters:
# texture_ids: array of four texture ids, one for each rotation
# shape: must be a string or a TileCollision instance.
func _init(name_id: String, args: Dictionary):
    var texture_ids: Array = args.get("texture_ids", [-1, -1, -1, -1])
    var shape = args.get("shape", "O")  # String or TileCollision
    var rotation: int = args.get("rotation", Rotation.NONE)

    if texture_ids.size() != 4:
        push_error("_texture_ids.size() must be 4, was " + str(texture_ids.size()))
    self.name_id = name_id
    self._texture_ids = texture_ids
    self.rotation = rotation
    if shape is String:
        self._shape = TileCollision.new(shape)
    else:
        self._shape = shape
    self._rail = args.get("rail", Rails.no_rail())

# Gets the texture id for the current rotation.
func get_texture_id() -> int:
    return self._texture_ids[self.rotation]

# Returns true if the other object tile is the same tile (same get_texture_id())
func equals(other: ObjectTile) -> bool:
    return self.get_texture_id() == other.get_texture_id()

# Returns true if the other object tile is the same tile, ignoring rotaitons.
func equals_ignore_rotation(other: ObjectTile) -> bool:
    return self._texture_ids[Rotation.NONE] == other._texture_ids[Rotation.NONE]

# Gets a tile with the given rotation. Does not modify this tile.
func with_rotation(rotation: int) -> ObjectTile:
    return get_script().new(self.name_id, {texture_ids=self._texture_ids, shape=self._shape, rotation=rotation})

# Gets the texture a rotated variant of this tile would have
func get_rotated_texture(rotation: int) -> int:
    return self._texture_ids[rotation]

# Most objects rotate around a single tile (their origin), "  O--" becomes "--O  " with a rotation of 180 degrees.
# However, sometimes you want to rotate around a position in between tiles, for example "   OP--" becomes " --dO  "
# instead of "--dO   " (note the amount of spaces). In that case you need a rotation offset.
func get_rotation_offset() -> Vector2:
    return self._shape.get_rotation_offset(self.rotation)


# Checks if this tile collides at the tile relative to this tile
func collides(tile_dx: int, tile_dy: int) -> bool:
    return self._shape.collides(self.rotation, tile_dx, tile_dy)

# Gets an array of all (relative) positions that are occupied by this tile (at the current rotation).
func get_occupied_tile_positions() -> PoolVector2Array:
    return self._shape.get_occupied_positions(self.rotation)

# Gets all possible rotations of this tile.
func all_rotations() -> Array:
    return [self.with_rotation(Rotation.NONE), self.with_rotation(Rotation.CLOCKWISE),
            self.with_rotation(Rotation.HALF), self.with_rotation(Rotation.COUNTER_CLOCKWISE)]

func get_rotation_position_fix() -> Vector2:
    var attempted_new_rotation = Rotation.next(self.rotation)
    var actual_new_rotation = self._get_rotation_from_texture_id(self._texture_ids[attempted_new_rotation])
    var attempted_offset = self._shape.get_rotation_offset(attempted_new_rotation)
    var actual_offset = self._shape.get_rotation_offset(actual_new_rotation)
    if attempted_offset != actual_offset:
        # print(self.name_id, " ", Rotation.rotation_to_string(attempted_new_rotation), attempted_offset, " ", 
        #      Rotation.rotation_to_string(actual_new_rotation), actual_offset, " RES ", attempted_offset - actual_offset)
        return attempted_offset - actual_offset
    return Vector2(0, 0)


# Creates the texture of this tile
func create_texture() -> Texture:
    var atlas = AtlasTexture.new()
    var texture_id = self.get_texture_id()
    atlas.atlas = _TILE_SET.tile_get_texture(texture_id)
    atlas.region = _TILE_SET.tile_get_region(texture_id)
    return atlas

# Gets the name under which this tile is registered.
func to_string() -> String:
    return self.name_id + "." + Rotation.rotation_to_string(self.rotation)

# Gets what the rotation would be if we would have the given texture. If multiple rotations share the
# same texture, the first rotation is returned. Returns -1 if no rotation matches the given texture.
func _get_rotation_from_texture_id(texture_id: int):
    for i in range(self._texture_ids.size()):
        if self._texture_ids[i] == texture_id:
            return i
    return -1
