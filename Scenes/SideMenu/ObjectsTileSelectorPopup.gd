extends Control

signal tile_selected
signal cancelled

const ObjectTile = preload("res://Scripts/ObjectTile.gd")

# Handles selection of tiles
func _input(event: InputEvent) -> void:
    if not self.visible:
        return

    if event is InputEventMouseButton and not event.is_pressed():
        var tilemap_objects: TileMap = $ObjectsTileMap
        var mouse_tile_pos = tilemap_objects.world_to_map(tilemap_objects.make_input_local(event).position)
        var texture_id = tilemap_objects.get_cellv(mouse_tile_pos)
        if texture_id == -1:
            emit_signal("cancelled")
            self.hide()
        else:
            var tile = Global.Registry.get_object_tile_from_texture_id(texture_id)
            emit_signal("tile_selected", tile)
            self.hide()
        self.get_tree().set_input_as_handled()