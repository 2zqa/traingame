extends Control

const GroundTile = preload("res://Scripts/GroundTile.gd")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass

# Handles selection of tiles
func _input(event: InputEvent) -> void:  
    if not (event is InputEventMouseButton) or not event.is_pressed():
        return  # Ignore anything that is not a click

    var tilemap_grounds: TileMap = $TileMap
    var mouse_tile_pos = tilemap_grounds.world_to_map(tilemap_grounds.make_input_local(event).position)
    if mouse_tile_pos != Vector2(0, 0):
        return  # Clicked outside the button

    # Open popup
    var popup = $GroundTileSelectorPopup
    popup.popup()

    self.get_tree().set_input_as_handled()
    


func _on_GroundSelector_tile_selected(tile: GroundTile) -> void:
    $TileMap.set_cell(0, 0, tile.texture_id)
