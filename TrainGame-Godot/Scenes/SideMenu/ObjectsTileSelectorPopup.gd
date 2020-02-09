extends Control

signal tile_selected  # Provides one argument of ObjectTile
signal eraser_selected  # Provides zero arguments.

const ObjectTile = preload("res://Scripts/ObjectTile.gd")


func _ready():
    for selectable_object in get_tree().get_nodes_in_group("SideMenuSelectableObjects"):
        selectable_object.connect("pressed_tile_id", self, "_onSideMenuSelectableObject_pressed")


func _onSideMenuSelectableObject_pressed(tile_id: int) -> void:
    var tile: ObjectTile = Global.Registry.get_object_tile_from_texture_id(tile_id)
    emit_signal("tile_selected", tile)
    self.hide()


func _on_EraseButton_pressed() -> void:
    emit_signal("eraser_selected")
    self.hide()


# Rotates the tile buttons, so that you can place rotated tiles.
func _on_RotateButton_pressed() -> void:
    for selectable_object in get_tree().get_nodes_in_group("SideMenuSelectableObjects"):
        var tile_id = selectable_object.tile_id
        var tile: ObjectTile = Global.Registry.get_object_tile_from_texture_id(tile_id)
        var rotated_tile_id = tile.get_rotated_texture(Rotation.next(tile.rotation))
        selectable_object.tile_id = rotated_tile_id
