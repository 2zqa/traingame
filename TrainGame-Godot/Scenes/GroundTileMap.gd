extends TileMap

const GroundTile = preload("res://Scripts/GroundTile.gd")


# Sets the tile at the given position
func set_tile(tile_position: Vector2, tile: GroundTile) -> void:
    self.set_cellv(tile_position, tile.texture_id)


# Gets the tile at the given position
func get_tile(tile_position: Vector2) -> GroundTile:
    return Global.Registry.get_ground_tile_from_texture_id(self.get_cellv(tile_position))


# Gets the tile coordinate from the given mouse event
func mouse_event_to_tile_pos(mouse: InputEventMouse) -> Vector2:
    return self.world_to_map(self.make_input_local(mouse).position)


# Gets the tile coordinate from the given viewport coordinate
func viewport_pos_to_tile_pos(position: Vector2) -> Vector2:
    return self.world_to_map(self.make_canvas_position_local(position))