extends Node2D

signal derailed

# These two must be kept in sync with other train cars, so only modify from the parent node
var _speed: float = 20 
var _derailed: bool

var in_train_offset: int = 0
var direction: int = Direction.EAST

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

func rotate_clockwise():
    self.direction = Direction.right(direction)
    self.position = Rotation.rotate(Rotation.CLOCKWISE, self.position)

func _set_relative_traincar_position(position: Vector2):
    # Sets the location of the traincar (a child of type Area2D) to the given
    # position.
    for node in self.get_children():
        if node is Area2D:
            node.position = position

func _update_sprite():
    for node in self.get_children():
        if node is Area2D and node.has_node("AnimatedSprite"):
            node.get_node("AnimatedSprite").frame = self.direction
