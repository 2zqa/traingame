extends Control

signal tile_selected  # Supplies one argument of type GroundTile

const GroundTile = preload("res://Scripts/GroundTile.gd")
const SingleTileDisplay = preload("res://Scenes/SideMenu/SideMenu.gd")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass

# Handles selection of tiles
func _unhandled_input(event: InputEvent) -> void:  
    if not Global.Mouse.is_left_released(event):
        return  # Ignore anything that is not a click release

    var display: SingleTileDisplay = $Display
    var local_mouse_pos = display.make_input_local(event).position
    if local_mouse_pos.x < 0 or local_mouse_pos.y < 0\
            or local_mouse_pos.x > display.size.x or local_mouse_pos.y > display.size.y:
        return  # Clicked outside the button

    # Open popup
    var popup = $GroundTileSelectorPopup
    popup.popup()

    self.get_tree().set_input_as_handled()
    


func _on_GroundSelector_tile_selected(tile: GroundTile) -> void:
    # Update UI
    var display : SingleTileDisplay = $Display
    display.tile_id = tile.texture_id

    # Forward
    emit_signal("tile_selected", tile)