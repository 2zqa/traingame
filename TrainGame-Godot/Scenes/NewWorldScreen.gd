extends MarginContainer

var random := RandomNumberGenerator.new()

func _ready():
    random.randomize()


func _on_CreateButton_pressed() -> void:
    var world_name = $Container/WorldNameEdit.text
    if world_name.length() == 0:
        $Container/ErrorLabel.text = "Please specify a world name"
        return
    Global.world_name = world_name
    Global.world_save_location = _create_world_save_location()
    if not get_tree().change_scene("res://Scenes/GameScreen.tscn"):
        push_error("Failed to change scene to GameScreen")


func _create_world_save_location() -> String:
    var file = File.new()
    while true:
        var file_name = Global.WORLD_FOLDER + str(random.randi_range(100, 2147483647)) + Global.SAVE_FILE_EXTENSION
        if not file.file_exists(file_name):
            return file_name
    return "This value is never returned, since it's after a while true loop"

func _on_CancelButton_pressed() -> void:
    if not get_tree().change_scene("res://Scenes/TitleScreen.tscn"):
        push_error("Failed to change scene to TitleScreen")
