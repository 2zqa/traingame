extends Control


export(Texture) var eraser_texture


signal tile_selected  # Supplies one argument of type ObjectTile
signal eraser_selected  # Supplies no arguments


# Handles selection of tiles
func _on_ObjectsTileSelectorButton_pressed() -> void:  
    # Open popup
    var popup = $ObjectsTileSelectorPopup
    popup.popup()

    self.get_tree().set_input_as_handled()
    


func _on_ObjectsTileSelectorPopup_tile_selected(tile: ObjectTile) -> void:
    # Update UI
    self.texture_normal = tile.create_texture()

    # Forward
    emit_signal("tile_selected", tile)


func _on_ObjectsTileSelectorPopup_eraser_selected() -> void:
    # Update UI
    self.texture_normal = eraser_texture

    # Forward
    emit_signal("eraser_selected")
