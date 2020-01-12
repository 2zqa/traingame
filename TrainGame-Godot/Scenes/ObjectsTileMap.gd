extends TileMap

const ObjectTile = preload("res://Scripts/ObjectTile.gd")


# Sets the tile at the given position
func set_tile(tile_position: Vector2, tile: ObjectTile) -> void:
    # Make sure to remove existing tile(s)
    var texture_size = self._get_texture_size(tile.get_texture_id())
    var texture_tile_size = Vector2(texture_size.x / self.cell_size.x, texture_size.y / self.cell_size.y)
    for dx in range(texture_tile_size.x):
        for dy in range(texture_tile_size.y):
            var existing_tile_result = self._search_texture(tile_position.x + dx, tile_position.y + dy)
            if existing_tile_result[2] != -1:
                # Found existing tile, remove
                self.set_cell(existing_tile_result[0], existing_tile_result[1], -1)       
    
    # Set a new tile
    self.set_cellv(tile_position, tile.get_texture_id())
        
# Gets the tile at the given position
func get_tile(tile_position: Vector2) -> ObjectTile:
    var tile_x = tile_position.x
    var tile_y = tile_position.y
    var result = self._search_texture(tile_x, tile_y)
    tile_x = result[0]
    tile_y = result[1]
    var texture_id = result[2]
    return Global.Registry.get_object_tile_from_texture_id(texture_id)

func _get_texture_size(texture_id: int) -> Vector2:
    return self.tile_set.tile_get_region(texture_id).size

# Searches for a tile that reaches this tile nearby. Returns [tile_x, tile_y, texture_id].
func _search_texture(tile_x: int, tile_y: int) -> Array:
    for dx in [0, -1, -2]:
        for dy in [0, -1, -2]:
            var texture_id = self.get_cell(tile_x + dx, tile_y + dy)
            if texture_id == -1:
                continue  # Continue searching
            var texture_size = self._get_texture_size(texture_id)
            if dx * -self.cell_size.x >= texture_size.x or dy * -self.cell_size.y >= texture_size.y:
                continue  # Outside texture
            return [tile_x + dx, tile_y + dy, texture_id]
    return [tile_x, tile_y, -1]

# Gets the tile coordinate from the given mouse event
func mouse_event_to_tile_pos(mouse: InputEventMouse) -> Vector2:
    return self.world_to_map(self.make_input_local(mouse).position)


# Gets the tile coordinate from the given viewport coordinate
func viewport_pos_to_tile_pos(position: Vector2) -> Vector2:
    return self.world_to_map(self.make_canvas_position_local(position))
