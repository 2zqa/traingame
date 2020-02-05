extends MarginContainer

var _world_names: PoolStringArray
var _world_files: PoolStringArray
var _world_id: int = -1

# Called when the node enters the scene tree for the first time.
func _ready():
    var worlds = FileIO.read_world_names(Global.WORLD_FOLDER)
    self._world_names = PoolStringArray(worlds.values())
    self._world_files = PoolStringArray(worlds.keys())

    var world_selector = $Container/WorldSelector
    if worlds.size() == 0:
        world_selector.add_item("<no worlds exist>", 0)
    else:
        world_selector.add_item("Select a world:", 0)

    var i = 1
    for world_name in self._world_names:
        world_selector.add_item(world_name, i)
        i += 1


func _on_CancelButton_pressed():
    if get_tree().change_scene("res://Scenes/MainMenu/TitleScreen.tscn") != OK:
        push_error("Failed to switch to TitleScreen")


func _set_buttons_enabled(enabled: bool) -> void:
    $Container/ButtonsContainer/PlayButton.disabled = not enabled
    $Container/ButtonsContainer/RenameButton.disabled = not enabled
    $Container/ButtonsContainer/DeleteButton.disabled = not enabled


func _on_WorldSelector_item_selected(world_id: int) -> void:
    print(world_id)
    self._world_id = world_id
    if world_id == 0:
        self._set_buttons_enabled(false)
    else:
        self._set_buttons_enabled(true)
