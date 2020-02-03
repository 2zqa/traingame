extends MarginContainer

export(PackedScene) var newWorldScene;


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


func _on_StartButton_pressed():
    if get_tree().change_scene_to(newWorldScene) != OK:
        return
