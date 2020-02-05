extends MarginContainer

export(PackedScene) var newWorldScene;
export(PackedScene) var loadWorldScene;

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


func _on_StartButton_pressed():
    if get_tree().change_scene_to(newWorldScene) != OK:
        push_error("Failed to load world creation screen")


func _on_LoadButton_pressed():
    if get_tree().change_scene_to(loadWorldScene) != OK:
        push_error("Failed to load world loading screen")
