extends Camera2D

const _MINIMUM_ZOOM = Vector2(0.5,0.5)
const _MAXIMUM_ZOOM = Vector2(4,4)


var active: bool

func _ready() -> void:
    self.active = true


func _clip_zoom(vector: Vector2) -> Vector2:
    return Vector2(
        min(_MAXIMUM_ZOOM.x, max(_MINIMUM_ZOOM.x, vector.x)),
        min(_MAXIMUM_ZOOM.y, max(_MINIMUM_ZOOM.y, vector.y)))

func _unhandled_input(event: InputEvent) -> void:
    if not active:
        return
    
    # Screen dragging with mouse
    if event is InputEventMouseMotion and Input.is_mouse_button_pressed(BUTTON_LEFT):
        self.offset -= event.relative
        self.get_tree().set_input_as_handled()

    # Zooming with mouse wheel
    if event is InputEventMouseButton and event.is_pressed():
        if event.button_index == BUTTON_WHEEL_UP:
            self.zoom = self._clip_zoom(self.zoom / 2)
            self.get_tree().set_input_as_handled()
        elif event.button_index == BUTTON_WHEEL_DOWN:
            self.zoom = self._clip_zoom(self.zoom * 2)
            self.get_tree().set_input_as_handled()
