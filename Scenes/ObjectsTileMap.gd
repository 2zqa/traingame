extends TileMap

const ObjectTile = preload("res://Scripts/ObjectTile.gd")


# Sets the tile at the given position
func set_tile(tile_position: Vector2, tile: ObjectTile) -> void:
    self.set_cellv(tile_position, tile.texture_id)


# Gets the tile at the given position
func get_tile(tile_position: Vector2) -> ObjectTile:
    return Global.Registry.get_object_tile_from_texture_id(self.get_cellv(tile_position))


# Gets the tile coordinate from the given mouse coordinate
func mouse_to_tile_pos(mouse: InputEventMouse) -> Vector2:
    return self.world_to_map(self.make_input_local(mouse).position)
