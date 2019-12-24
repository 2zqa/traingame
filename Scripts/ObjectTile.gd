class_name ObjectTile

export(String) var name_id
export(int) var texture_id

func _init(name_id: String, texture_id: int):
    self.name_id = name_id
    self.texture_id = texture_id
