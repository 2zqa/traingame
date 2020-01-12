class_name ObjectTile

enum Rotation {
    NONE,  # No rtation
    CLOCKWISE,  # 90 degrees clockwise
    HALF,  # 180 degrees
    COUNTER_CLOCKWISE  # 270 degrees clockwise
}

export(String) var name_id
export(Rotation) var rotation
var texture_ids: Array

func _init(name_id: String, texture_ids: Array, rotation: int = Rotation.NONE):
    if texture_ids.size() != 4:
        push_error("texture_ids.size() must be 4, was " + str(texture_ids.size()))
    self.name_id = name_id
    self.texture_ids = texture_ids
    self.rotation = rotation

# Gets the texture id for the current rotation.
func get_texture_id() -> int:
    return self.texture_ids[self.rotation]

# Gets a tile with the given rotation. Does not modify this tile.
func with_rotation(rotation: int) -> ObjectTile:
    if rotation == self.rotation:
        return self
    return get_script().new(self.name_id, self.texture_ids, rotation)

func all_rotations() -> Array:
    return [self.with_rotation(Rotation.NONE), self.with_rotation(Rotation.CLOCKWISE),
            self.with_rotation(Rotation.HALF), self.with_rotation(Rotation.COUNTER_CLOCKWISE)]
