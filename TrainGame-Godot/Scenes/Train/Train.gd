extends Node2D

var _speed := 20
var _direction := Direction.EAST

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
    var next_position = Global.rails.add_to_position(previous_position, self._direction, self._speed * delta)
    self._direction = Global.rails.to_updated_direction(self._direction, previous_position, next_position)
    self.position = next_position

    for train_car in self.get_children():
        var new_position = Global.rails.add_to_position(self.position, self._direction, train_car.in_train_offset)
        var new_position_relative = new_position - self.position
        train_car.direction = Global.rails.to_updated_direction(train_car.direction, train_car.position, new_position_relative)
        train_car.position = new_position_relative

func _on_TrainFront_derailed() -> void:
    print("Train derailed")
    self.set_speed(0)

func _draw():
    self.draw_circle(Vector2(0, 0), 20, Color.black)
