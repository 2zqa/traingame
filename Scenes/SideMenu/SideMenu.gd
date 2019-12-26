extends Control

const GroundTileSelectorPopup = preload("res://Scenes/SideMenu/GroundTileSelectorPopup.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#    pass


func _on_SelectGroundButton_pressed() -> void:
    var popup = GroundTileSelectorPopup.instance()
    self.add_child(popup)
