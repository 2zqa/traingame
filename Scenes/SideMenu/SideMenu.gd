extends Control

# Fired when the selected object is changed
# Object is a GroundTile or an ObjectTile.
signal option_selected  


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#    pass



func _on_GroundTileSelectorButton_tile_selected(tile: GroundTile):
    emit_signal("option_selected", tile)


func _on_ObjectsTileSelectorButton_tile_selected(tile: ObjectTile):
    emit_signal("option_selected", tile)
