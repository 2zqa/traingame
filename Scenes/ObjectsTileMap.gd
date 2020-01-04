extends TileMap

const ObjectTile = preload("res://Scripts/ObjectTile.gd")


# Sets the tile at the given position
func set_tile(tile_position: Vector2, tile: ObjectTile) -> void:
    self.set_cellv(tile_position, tile.texture_id, tile.is_texture_x_flipped(), tile.is_texture_y_flipped(), tile.is_texture_transposed())


# Gets the tile at the given position
func get_tile(tile_position: Vector2) -> ObjectTile:
    var tile_x = tile_position.x
    var tile_y = tile_position.y
    
    var x_flipped = self.is_cell_x_flipped(tile_x, tile_y)
    var y_flipped = self.is_cell_y_flipped(tile_x, tile_y)
    var transposed = self.is_cell_transposed(tile_x, tile_y)
    var texture_id = self.get_cell(tile_x, tile_y)
    return Global.Registry.get_object_tile_from_texture(texture_id, transposed, x_flipped, y_flipped)


# Gets the tile coordinate from the given mouse event
func mouse_event_to_tile_pos(mouse: InputEventMouse) -> Vector2:
    return self.world_to_map(self.make_input_local(mouse).position)


# Gets the tile coordinate from the given viewport coordinate
func viewport_pos_to_tile_pos(position: Vector2) -> Vector2:
    return self.world_to_map(self.make_canvas_position_local(position))
