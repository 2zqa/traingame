extends Node2D

var _speed := 20  # 0 or positive
var _driving_direction := Direction.WEST
var _driving_backwards := false

func rotate_clockwise():
    if Global.rails == null:
        return
    self.position = Rotation.rotate(Rotation.CLOCKWISE, self.position)
    self._direction = Direction.right(self._direction)
    for train_car in self.get_children():
        train_car.rotate_clockwise()

func set_speed(speed: float) -> void:
    self._speed = speed

func _process(delta: float) -> void:
    if Global.rails == null or self._speed == 0:
        return

    var previous_position = self.position
    var addition_result = Global.rails.add_to_position(previous_position, self._driving_direction, self._speed * delta)
    var next_position = addition_result[0]
    self._driving_direction = addition_result[1]
    self.position = next_position

    for train_car in self.get_children():
        addition_result = Global.rails.add_to_position(self.position, train_car.driving_direction, train_car.in_train_offset)
        train_car.position = addition_result[0] - self.position
        train_car.driving_direction = addition_result[1]

        # Sync up
        train_car.set_speed(self._speed, self._driving_backwards)


func _on_TrainFront_derailed() -> void:
    print("Train derailed")
    self.set_speed(0)

func _draw():
    self.draw_circle(Vector2(0, 0), 10, Color.black)
