extends Control

signal tile_selected  # Supplies one argument of type GroundTile

const SingleTileDisplay = preload("res://Scenes/SingleTileDisplay.gd")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass

# Handles selection of tiles
func _on_GroundTileSelectorButton_pressed() -> void:

    # Open popup
    var popup = $GroundTileSelectorPopup
    popup.popup()

    self.get_tree().set_input_as_handled()


func _on_GroundSelector_tile_selected(tile: GroundTile) -> void:
    # Update UI
    self.texture_normal = tile.create_texture()

    # Forward
    emit_signal("tile_selected", tile)
