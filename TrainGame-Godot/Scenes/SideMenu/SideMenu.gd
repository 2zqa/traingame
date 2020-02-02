extends Control

# Fired when the selected object is changed
# Object is an InteractOption
signal option_selected

# Fired when the rotation button is pressed. Supplies no arguments.
signal rotation_requested 

# Fired when the "Save and Quit" button is pressed. Supplies no arguments.
signal save_and_quit_requested

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.


func _on_PauseButton_save_and_quit_requested() -> void:
    emit_signal("save_and_quit_requested")  # Forwards


func _on_GroundTileSelectorButton_tile_selected(tile: GroundTile):
    emit_signal("option_selected", InteractOption.new(tile))


func _on_ObjectsTileSelectorButton_tile_selected(tile: ObjectTile):
    if tile == null:
        emit_signal("option_selected", "delete")
    else:
        emit_signal("option_selected", InteractOption.new(tile))


func _on_MoveButton_pressed():
    emit_signal("option_selected", InteractOption.new("move"))


func _on_RotateButton_pressed():
    emit_signal("rotation_requested")
