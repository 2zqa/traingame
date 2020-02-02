extends TextureButton

signal save_and_quit_requested  # Supplies no arguments.

func _on_PauseButton_pressed() -> void:
    $PauseMenu.show()

func _on_PauseMenu_save_and_quit_button_pressed() -> void:
    emit_signal("save_and_quit_requested")
