class_name ObjectTile

var Collisions := preload("res://Scripts/Collisions.gd").new()
var tileset := preload("res://TileSets/Objects.tres")

enum Rotation {
    NONE = 0,  # No rtation
    CLOCKWISE = 1,  # 90 degrees clockwise
    HALF = 2,  # 180 degrees
    COUNTER_CLOCKWISE = 3  # 270 degrees clockwise
}

var name_id: String
var rotation: int
var texture_ids: Array
var _shape: Rect2

func _init(name_id: String, texture_ids: Array, rotation: int = Rotation.NONE):
    if texture_ids.size() != 4:
        push_error("texture_ids.size() must be 4, was " + str(texture_ids.size()))
    self.name_id = name_id
    self.texture_ids = texture_ids
    self.rotation = rotation
    
    var shape = tileset.tile_get_shape(texture_ids[rotation], 0)
    if shape != null:
        self._shape = Collisions.get_rectangle(shape)
    else:
        self._shape = Rect2(0, 0, 1, 1)

# Gets the texture id for the current rotation.
func get_texture_id() -> int:
    return self.texture_ids[self.rotation]

# Gets a simple rectangle describing the shape of this tile
func get_rectangular_shape() -> Rect2:
    return self._shape

# Returns true if the other object tile is the same tile (same get_texture_id())
func equals(other: ObjectTile) -> bool:
    return self.get_texture_id() == other.get_texture_id()

# Gets a tile with the given rotation. Does not modify this tile.
func with_rotation(rotation: int) -> ObjectTile:
    if rotation == self.rotation:
        return self
    return get_script().new(self.name_id, self.texture_ids, rotation)

func all_rotations() -> Array:
    return [self.with_rotation(Rotation.NONE), self.with_rotation(Rotation.CLOCKWISE),
            self.with_rotation(Rotation.HALF), self.with_rotation(Rotation.COUNTER_CLOCKWISE)]
