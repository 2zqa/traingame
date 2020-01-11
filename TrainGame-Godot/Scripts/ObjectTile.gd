class_name ObjectTile

enum Rotation {
    NONE,  # No rtation
    CLOCKWISE,  # 90 degrees clockwise
    HALF,  # 180 degrees
    COUNTER_CLOCKWISE  # 270 degrees clockwise
}

export(String) var name_id
export(int) var texture_id
export(Rotation) var rotation

func _init(name_id: String, texture_id: int, rotation: int = Rotation.NONE):
    self.name_id = name_id
    self.texture_id = texture_id
    self.rotation = rotation

func is_texture_transposed() -> bool:
    # Returns true if the texture should be transposed when drawn.
    return self.rotation == Rotation.CLOCKWISE or self.rotation == Rotation.COUNTER_CLOCKWISE

func is_texture_x_flipped() -> bool:
    # Returns true if the texture should be flipped in the x direction when drawn.
    return self.rotation == Rotation.CLOCKWISE or self.rotation == Rotation.HALF

func is_texture_y_flipped() -> bool:
    # Returns true if the texture should be flipped in the ydirection when drawn.
    return self.rotation == Rotation.HALF or self.rotation == Rotation.COUNTER_CLOCKWISE

func with_rotation(rotation: int) -> ObjectTile:
    # Gets a tile with the given rotation. Does not modify this tile.
    if rotation == self.rotation:
        return self
    return get_script().new(self.name_id, self.texture_id, rotation)

func all_rotations() -> Array:
    return [self.with_rotation(Rotation.NONE), self.with_rotation(Rotation.CLOCKWISE),
            self.with_rotation(Rotation.HALF), self.with_rotation(Rotation.COUNTER_CLOCKWISE)]
