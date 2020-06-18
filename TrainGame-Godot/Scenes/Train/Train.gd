extends Node2D

func rotate_clockwise():
    self.position = Rotation.rotate(Rotation.CLOCKWISE, self.position)
    for train_car in self.get_children():
        train_car.rotate_clockwise()
