extends Node2D

signal derailed

# These two must be kept in sync with other train cars, so only modify from the parent node
var _speed: float = 20 
var _derailed: bool

var in_train_offset: int = 0
var driving_direction: int = Direction.EAST
var _driving_backwards: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
    self._derailed = false
    
    # Change position into offset
    self.in_train_offset = int(self.position.x)
    self.position.x = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
    if Global.rails == null or self._speed == 0:
        return

    self._derailed = false
    if self._derailed:
        emit_signal("derailed")
    self._update_sprite()

func rotate_clockwise() -> void:
    self.driving_direction = Direction.right(driving_direction)
    self.position = Rotation.rotate(Rotation.CLOCKWISE, self.position)

func set_speed(speed: float, driving_backwards: bool) -> void:
    self._speed = speed
    self._driving_backwards = driving_backwards

func _update_sprite() -> void:
    var facing_direction = self.driving_direction
    if self._driving_backwards:
        facing_direction = Direction.opposite(facing_direction)
    for node in self.get_children():
        if node is Area2D and node.has_node("AnimatedSprite"):
            node.get_node("AnimatedSprite").frame = facing_direction
