class_name ObjectTile


var name_id: String
var rotation: int
var _texture_ids: Array
var _collision: TileCollision

# Creates a new instance. collision must be a string or a TileCollision instance.
func _init(name_id: String, _texture_ids: Array, collision = "O", rotation: int = Rotation.NONE):
    if _texture_ids.size() != 4:
        push_error("_texture_ids.size() must be 4, was " + str(_texture_ids.size()))
    self.name_id = name_id
    self._texture_ids = _texture_ids
    self.rotation = rotation
    if collision is String:
        collision = TileCollision.new(collision)
    self._collision = collision

# Gets the texture id for the current rotation.
func get_texture_id() -> int:
    return self._texture_ids[self.rotation]

# Returns true if the other object tile is the same tile (same get_texture_id())
func equals(other: ObjectTile) -> bool:
    return self.get_texture_id() == other.get_texture_id()

# Gets a tile with the given rotation. Does not modify this tile.
func with_rotation(rotation: int) -> ObjectTile:
    if self._texture_ids[rotation] == self._texture_ids[self.rotation]:
        return self  # New tile will look exactly the same
    return get_script().new(self.name_id, self._texture_ids, self._collision, rotation)

# Gets the texture a rotated variant of this tile would have
func get_rotated_texture(rotation: int) -> int:
    return self._texture_ids[rotation]

# Checks if this tile collides at the tile relative to this tile
func collides(tile_dx: int, tile_dy: int) -> bool:
    return self._collision.collides(self.rotation, tile_dx, tile_dy)

func get_occupied_tile_positions() -> PoolVector2Array:
    return self._collision.get_occupied_positions(self.rotation)

func all_rotations() -> Array:
    return [self.with_rotation(Rotation.NONE), self.with_rotation(Rotation.CLOCKWISE),
            self.with_rotation(Rotation.HALF), self.with_rotation(Rotation.COUNTER_CLOCKWISE)]
