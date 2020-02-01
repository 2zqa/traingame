class_name Mouse

static func is_left_released(event: InputEvent) -> bool:
    # Returns true if the given input event is an event where the left mouse button was released.
    return event is InputEventMouseButton and event.button_index == BUTTON_LEFT and not event.is_pressed()

# Returns a pointer id for the given input event. If you touch the screen at two different locations,
# both locations will have different pointer ids. If you're using a mouse, -1 will be returned.
static func get_pointer_id(event: InputEvent) -> int:
    if event is InputEventScreenDrag or event is InputEventScreenTouch:
        return event.index
    return -1
