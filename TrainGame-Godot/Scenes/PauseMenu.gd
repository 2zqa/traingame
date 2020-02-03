extends Popup

signal save_and_quit_button_pressed  # Used when the "Save and Quit" button is pressed

func _on_ContinueButton_pressed() -> void:
    self.hide()


func _on_SaveAndQuitButton_pressed() -> void:
    self.hide()
    emit_signal("save_and_quit_button_pressed")


# Prevent clicking outside the window from doing anything
func _unhandled_input(_event: InputEvent) -> void:
    if self.visible:
        self.get_tree().set_input_as_handled()
