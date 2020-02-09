extends TileMap

class_name ObjectsTileMap

const ObjectTile = preload("res://Scripts/ObjectTile.gd")


# Sets the tile at the given position
func set_tile(tile_position: Vector2, tile: ObjectTile, overwrite: bool = true) -> void:
    # Make sure to remove existing tile(s)
    for delta in tile.get_occupied_tile_positions():
        var existing_tile_result = self._search_texture(tile_position.x + delta.x, tile_position.y + delta.y)
        if existing_tile_result[2] != Global.Registry.OBJECT_EMPTY:
            # Found existing tile, remove or abort
            if not overwrite:
                return
            self.set_cell(existing_tile_result[0], existing_tile_result[1], -1)       
    
    # Set a new tile
    self.set_cellv(tile_position, tile.get_texture_id())


# Gets the tile at the given position.
func get_tile(tile_pos: Vector2) -> ObjectTile:
    var result = self._search_texture(int(tile_pos.x), int(tile_pos.y))
    return result[2]


# Gets the tile with the origin at the given position, without looking at the full object.
func get_tile_no_search(tile_x: int, tile_y: int) -> ObjectTile:
    var texture_id = self.get_cell(tile_x, tile_y)
    return Global.Registry.get_object_tile_from_texture_id(texture_id)


# Searches for a tile that reaches this tile nearby. Returns [tile_x, tile_y, texture_id].
func _search_texture(tile_x: int, tile_y: int) -> Array:
    for dx in [0, -1, 1, -2, 2]:
        for dy in [0, -1, 1, -2, 2]:
            var object_tile = get_tile_no_search(tile_x + dx, tile_y + dy)
            if object_tile.equals(Global.Registry.OBJECT_EMPTY):
                continue

            if not object_tile.collides(-dx, -dy):
                continue  # Outside texture
            return [tile_x + dx, tile_y + dy, object_tile]
    return [tile_x, tile_y, Global.Registry.OBJECT_EMPTY]


# Gets the tile coordinate from the given mouse event
func mouse_event_to_tile_pos(mouse: InputEvent) -> Vector2:
    return self.world_to_map(self.make_input_local(mouse).position)


# Gets the tile coordinate from the given viewport coordinate
func viewport_pos_to_tile_pos(position: Vector2) -> Vector2:
    return self.world_to_map(self.make_canvas_position_local(position))

# Rotates all tiles 90 degrees clockwise
func rotate_clockwise() -> void:
    # Record all tiles
    var texture_id_array = PoolIntArray()
    var positions_array = self.get_used_cells()
    for tile_pos in self.get_used_cells():
        texture_id_array.append(self.get_cellv(tile_pos))
    
    # Set tiles
    self.clear()
    var i = 0
    for texture_id in texture_id_array:
        var object_tile = Global.Registry.get_object_tile_from_texture_id(texture_id)
        var new_texture_id = object_tile.get_rotated_texture(Rotation.next(object_tile.rotation))
        var tile_pos = positions_array[i]
        var rotation_offset = object_tile.get_rotation_offset()
        var rotation_offset_inverse = Vector2(rotation_offset.y, rotation_offset.x)
        var rotated_tile_pos = Rotation.rotate(Rotation.CLOCKWISE, tile_pos + rotation_offset) + rotation_offset_inverse
        self.set_cellv(rotated_tile_pos, new_texture_id)

        i += 1
    
