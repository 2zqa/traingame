# Pulls itself, and zero or more TrainCars
extends Node2D

const CAR = preload("res://Scenes/Train/TrainCar1.tscn")

var _speed := 20  # 0 or positive
var _driving_direction := Direction.WEST
var _driving_backwards := false
var _cars: Array  # Array of TrainCar

func _ready():
    self._cars = []
    self.call_deferred("_add_cars")

# Constructs the actual train
func _add_cars() -> void:
    # Move all child notes one level up - in this way, drawing order
    # is correct. (Otherwise, the train is seen as one object by the
    # scenery.)
    for child in self.get_children():
        self.remove_child(child)
        get_parent().add_child(child)
        self._cars.append(child)

func rotate_clockwise():
    if Global.rails == null:
        return
    self.position = Rotation.rotate(Rotation.CLOCKWISE, self.position)
    self._driving_direction = Direction.right(self._driving_direction)
    for train_car in self._cars:
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

    for train_car in self._cars:
        # Find direction of train car towards train
        var relative_direction = self._driving_direction
        if train_car.in_train_offset < 0:
            relative_direction = Direction.opposite(self._driving_direction)
        
        # Move the train car
        addition_result = Global.rails.add_to_position(self.position, relative_direction, abs(train_car.in_train_offset))
        train_car.position = addition_result[0]
        
        # Get the driving direction correct (depending on the direction from the middle of the train)
        var train_car_direction = addition_result[1]
        if train_car.in_train_offset < 0:
            train_car.driving_direction = Direction.opposite(train_car_direction)
        else:
            train_car.driving_direction = train_car_direction

        # Sync up
        train_car.set_speed(self._speed, self._driving_backwards)


func _on_TrainFront_derailed() -> void:
    print("Train derailed")
    self.set_speed(0)

