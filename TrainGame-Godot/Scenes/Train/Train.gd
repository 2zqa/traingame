extends Node2D

func rotate_clockwise():
    self.position = Rotation.rotate(Rotation.CLOCKWISE, self.position)
    for train_car in self.get_children():
        train_car.rotate_clockwise()

func set_speed(speed: float) -> void:
    for train_car in self.get_children():
        train_car._speed = speed

func _on_TrainFront_derailed() -> void:
    print("Train derailed")
    self.set_speed(0)
