extends TileMap

class_name GroundTileMap

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
    while i < texture_id_array.size():
        var texture_id = texture_id_array[i]
        var tile_pos = positions_array[i]
        self.set_cellv(Rotation.rotate(Rotation.CLOCKWISE, tile_pos), texture_id)
        
        i += 1
    
