extends Control

signal tile_selected

const GroundTile = preload("res://Scripts/GroundTile.gd")

# Handles selection of tiles
func _input(event: InputEvent) -> void:
    if event is InputEventMouseButton and event.is_pressed():
        var tilemap_grounds: TileMap = $GroundTileMap
        var mouse_tile_pos = tilemap_grounds.world_to_map(tilemap_grounds.make_input_local(event).position)
        var texture_id = tilemap_grounds.get_cellv(mouse_tile_pos)
        if texture_id != -1:
            var tile = Global.Registry.get_ground_tile_from_texture_id(texture_id)
            emit_signal("tile_selected", tile)

        self.queue_free()
        self.get_tree().set_input_as_handled()