extends Camera2D

const _MINIMUM_ZOOM = Vector2(0.5, 0.5)
const _MAXIMUM_ZOOM = Vector2(4, 4)
const _MOVE_DISTANCE = 100

var active: bool

func _ready() -> void:
    self.active = true


func _clip_zoom(vector: Vector2) -> Vector2:
    return Vector2(
        min(_MAXIMUM_ZOOM.x, max(_MINIMUM_ZOOM.x, vector.x)),
        min(_MAXIMUM_ZOOM.y, max(_MINIMUM_ZOOM.y, vector.y)))

func _unhandled_input(event: InputEvent) -> void:
    
    # Screen dragging with mouse
    if active:
        if event is InputEventMouseMotion and event.get_button_mask() != 0:
            self.offset -= event.relative
            self.get_tree().set_input_as_handled()

    # Zooming and moving with mouse wheel
    if event is InputEventMouseButton and event.is_pressed() and \
            (event.button_index == BUTTON_WHEEL_UP or event.button_index == BUTTON_WHEEL_DOWN):
        self.get_tree().set_input_as_handled()
        var control = Input.is_key_pressed(KEY_CONTROL)
        var shift = Input.is_key_pressed(KEY_SHIFT)
        
        if control and not shift:
            # Zooming
            if event.button_index == BUTTON_WHEEL_UP:
                self.zoom = self._clip_zoom(self.zoom / 2)
            else:
                self.zoom = self._clip_zoom(self.zoom * 2)
        elif shift and not control:
            # Horizontal scrolling
            if event.button_index == BUTTON_WHEEL_UP:
                self.offset += Vector2(-_MOVE_DISTANCE, 0) * self.zoom
            else:
                self.offset += Vector2(_MOVE_DISTANCE, 0) * self.zoom
        elif not shift and not control:
            # Vertical scrolling
            if event.button_index == BUTTON_WHEEL_UP:
                self.offset += Vector2(0, -_MOVE_DISTANCE) * self.zoom
            else:
                self.offset += Vector2(0, _MOVE_DISTANCE) * self.zoom
