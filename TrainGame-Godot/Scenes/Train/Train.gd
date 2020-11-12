extends Node2D

var _speed := 20
var _direction := Direction.WEST

func rotate_clockwise():
    if Global.rails == null:
        return
    self.position = Rotation.rotate(Rotation.CLOCKWISE, self.position)
    self._direction = Direction.right(self._direction)
    for train_car in self.get_children():
        train_car.rotate_clockwise()

func set_speed(speed: float) -> void:
    for train_car in self.get_children():
        train_car._speed = speed

func _process(delta: float) -> void:
    if Global.rails == null or self._speed == 0:
        return

    var previous_position = self.position
    var addition_result = Global.rails.add_to_position(previous_position, self._direction, self._speed * delta)
    var next_position = addition_result[0]
    self._direction = addition_result[1]
    self.position = next_position

    for train_car in self.get_children():
        addition_result = Global.rails.add_to_position(self.position, self._direction, train_car.in_train_offset)
        train_car.position = addition_result[0] - self.position
        train_car.direction = addition_result[1]


func _on_TrainFront_derailed() -> void:
    print("Train derailed")
    self.set_speed(0)

func _draw():
    self.draw_circle(Vector2(0, 0), 10, Color.black)
