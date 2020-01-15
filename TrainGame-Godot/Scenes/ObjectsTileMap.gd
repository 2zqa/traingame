extends TileMap

const ObjectTile = preload("res://Scripts/ObjectTile.gd")


# Sets the tile at the given position
func set_tile(tile_position: Vector2, tile: ObjectTile) -> void:
    # Make sure to remove existing tile(s)
    var texture_shape = tile.get_rectangular_shape()
    for dx in range(texture_shape.position.x / self.cell_size.x, texture_shape.end.x / self.cell_size.x):
        for dy in range(texture_shape.position.y / self.cell_size.y, texture_shape.end.y / self.cell_size.y):
            var existing_tile_result = self._search_texture(tile_position.x + dx, tile_position.y + dy)
            if existing_tile_result[2] != Global.Registry.OBJECT_EMPTY:
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
    return result[2]

func _get_tile_no_search(tile_x: int, tile_y: int) -> ObjectTile:
    var texture_id = self.get_cell(tile_x, tile_y)
    return Global.Registry.get_object_tile_from_texture_id(texture_id)


# Searches for a tile that reaches this tile nearby. Returns [tile_x, tile_y, texture_id].
func _search_texture(tile_x: int, tile_y: int) -> Array:
    for dx in [0, -1, -2]:
        for dy in [0, -1, -2]:
            var object_tile = _get_tile_no_search(tile_x + dx, tile_y + dy)
            if object_tile.equals(Global.Registry.OBJECT_EMPTY):
                continue

            var shape = object_tile.get_rectangular_shape()
            var dx_texture = dx * -self.cell_size.x
            var dy_texture = dy * -self.cell_size.y
            if dx_texture < shape.position.x or dy_texture < shape.position.y or\
                   dx_texture >= shape.end.x or dy_texture >= shape.end.y:
                continue  # Outside texture
            return [tile_x + dx, tile_y + dy, object_tile]
    return [tile_x, tile_y, Global.Registry.OBJECT_EMPTY]

# Gets the tile coordinate from the given mouse event
func mouse_event_to_tile_pos(mouse: InputEventMouse) -> Vector2:
    return self.world_to_map(self.make_input_local(mouse).position)


# Gets the tile coordinate from the given viewport coordinate
func viewport_pos_to_tile_pos(position: Vector2) -> Vector2:
    return self.world_to_map(self.make_canvas_position_local(position))
