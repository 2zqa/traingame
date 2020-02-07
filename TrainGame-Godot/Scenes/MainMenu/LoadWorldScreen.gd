extends MarginContainer

var _world_names: PoolStringArray
var _world_files: PoolStringArray
var _world_id: int = -1
var _new_world_name: String = ""

# Called when the node enters the scene tree for the first time.
func _ready():
    self._initialize_world_list()


# Reads which worlds are available, and populates the selection box based on that
func _initialize_world_list():
    var worlds = FileIO.read_world_names(Global.WORLD_FOLDER)
    self._world_names = PoolStringArray(worlds.values())
    self._world_files = PoolStringArray(worlds.keys())

    var world_selector : OptionButton = $Container/WorldSelector
    world_selector.clear()
    if worlds.size() == 0:
        world_selector.add_item("<no worlds exist>", 0)
    else:
        world_selector.add_item("Select a world:", 0)

    var i = 1
    for world_name in self._world_names:
        world_selector.add_item(world_name + " ", i)  # The space is added after the world name to prevent translation of it
        i += 1


func _on_CancelButton_pressed() -> void:
    if get_tree().change_scene("res://Scenes/MainMenu/TitleScreen.tscn") != OK:
        push_error("Failed to switch to TitleScreen")


func _on_PlayButton_pressed() -> void:
    var world_index = self._world_id - 1
    if world_index < 0:
        return
    Global.world_save_location = self._world_files[world_index]
    Global.world_name = self._world_names[world_index]
    if get_tree().change_scene("res://Scenes/GameScreen.tscn") != OK:
        push_error("Failed to switch to GameScreen")

func _on_DeleteButton_pressed() -> void:
    var world_index = self._world_id - 1
    if world_index < 0:
        return
    var confirmation_dialog: ConfirmationDialog = $DeleteConfirmationDialog
    var world_name = self._world_names[world_index]
    confirmation_dialog.dialog_text = tr("You are about to delete the entire world named \"%s\", which cannot be undone.") % world_name \
            + "\n\n" + tr("Are you sure you want to continue?")
    confirmation_dialog.popup_centered()


func _on_DeleteConfirmationDialog_confirmed() -> void:
    var world_index = self._world_id - 1
    if world_index < 0:
        return
    if FileIO.delete_world(self._world_files[world_index]) == OK:
        $Container/FeedbackLabel.text = "World is deleted!"
        self._world_id = -1
        self._initialize_world_list()
        self._set_buttons_enabled(false)


func _set_buttons_enabled(enabled: bool) -> void:
    $Container/ButtonsContainer/PlayButton.disabled = not enabled
    $Container/ButtonsContainer/RenameButton.disabled = not enabled
    $Container/ButtonsContainer/DeleteButton.disabled = not enabled


func _on_WorldSelector_item_selected(world_id: int) -> void:
    $Container/FeedbackLabel.text = ""
    self._world_id = world_id
    if world_id == 0:
        self._set_buttons_enabled(false)
    else:
        self._set_buttons_enabled(true)


func _on_RenameButton_pressed() -> void:
    var world_index = self._world_id - 1
    if world_index < 0:
        return

    self._new_world_name = ""  # Clear recorded text
    var rename_dialog: ConfirmationDialog = $RenameDialog
    rename_dialog.popup_centered()
    var world_name_edit: LineEdit = rename_dialog.find_node("WorldNameEdit")
    world_name_edit.text = ""
    world_name_edit.grab_focus()


func _on_WorldNameEdit_text_changed(new_text: String) -> void:
    self._new_world_name = new_text


# Called by the OK button in the rename dialog
func _on_RenameDialog_confirmed() -> void:
    if self._new_world_name.length() == 0:
        $Container/FeedbackLabel.text = "Renaming failed: world name cannot be empty."
        return

    var world_index = self._world_id - 1
    if world_index < 0:
        return
    
    if FileIO.write_name(self._world_files[world_index], self._new_world_name) == OK:
        self._initialize_world_list()
        $Container/FeedbackLabel.text = tr("World renamed to \"%s\"!") % self._new_world_name
        $Container/WorldSelector.select(self._world_id)  # And select correct option again

# Called when pressing Enter in the text field of the rename dialog.
func _on_WorldNameEdit_text_entered(new_text: String) -> void:
    self._new_world_name = new_text
    $RenameDialog.hide()
    self._on_RenameDialog_confirmed()
