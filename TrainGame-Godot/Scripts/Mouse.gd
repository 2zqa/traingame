extends Node

func is_left_released(event: InputEvent) -> bool:
    # Returns true if the given input event is an event where the left mouse button was released.
    return event is InputEventMouseButton and event.button_index == BUTTON_LEFT and not event.is_pressed()
