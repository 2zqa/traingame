extends Node2D

signal derailed

# These two must be kept in sync with other train cars, so only modify from the parent node
var _speed: float = 20 
var _derailed: bool


var _direction: int = Direction.EAST
var _next_rail_tile_pos: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
    self._derailed = false

# Finds the next track piece. Returns false if no such piece exists
func _find_next_rail() -> void:
    var tile_pos = Global.rails.to_tile_pos(self.to_global(Vector2(0, 0)))
    var path: Path2D = $Path2D
    var path_progress: PathFollow2D = $Path2D/PathFollow2D

    # Update path
    self._next_rail_tile_pos = Global.rails.get_next_rail(tile_pos, self._direction)
    path.curve = Global.rails.get_path(tile_pos, self._direction)
    path_progress.offset = 0
    
    # Update direction in case the train is going through a corner
    if self._direction == Direction.EAST or self._direction == Direction.WEST:
        if self._next_rail_tile_pos.y < tile_pos.y:
            self._direction = Direction.NORTH
        elif self._next_rail_tile_pos.y > tile_pos.y:
            self._direction = Direction.SOUTH
    elif self._direction == Direction.NORTH or self._direction == Direction.SOUTH:
        if self._next_rail_tile_pos.x < tile_pos.x:
            self._direction = Direction.WEST
        elif self._next_rail_tile_pos.x > tile_pos.x:
            self._direction = Direction.EAST

    self._derailed = path.curve.get_point_count() < 2
    if self._derailed:
        emit_signal("derailed")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    if Global.rails == null or self._speed == 0:
        return

    var path: Path2D = $Path2D
    if path.curve.get_point_count() < 2 and not self._derailed:
        # Start driving
        
        # Snap to grid
        var tile_pos = Global.rails.to_tile_pos(self.to_global(Vector2(0, 0)))
        self._teleport_to(tile_pos)
        
        print("Finding first rail")
        self._find_next_rail()
        return

    # Continue driving
    var path_progress: PathFollow2D = $Path2D/PathFollow2D
    path_progress.offset += _speed * delta
    self._set_relative_traincar_position(path_progress.position)
    if path_progress.unit_offset >= 1:
        # Finish this rail
        self._teleport_to(self._next_rail_tile_pos)
        self._find_next_rail()
    self._update_sprite()

func _teleport_to(tile_pos: Vector2):
    self.position += self.to_local(Global.rails.to_world_pos(tile_pos) + Vector2(8, 8))
    var path_progress: PathFollow2D = $Path2D/PathFollow2D
    path_progress.offset = 0
    self._set_relative_traincar_position(path_progress.position)

func _set_relative_traincar_position(position: Vector2):
    for node in self.get_children():
        if node is Area2D:
            node.position = position

func _to_array(curve: Curve2D) -> PoolVector2Array:
    var array = PoolVector2Array()
    for i in range(curve.get_point_count()):
        array.append(curve.get_point_position(i))
    return array

func _update_sprite():
    for node in self.get_children():
        if node is Area2D and node.has_node("AnimatedSprite"):
            node.get_node("AnimatedSprite").frame = self._direction

func rotate_clockwise():
    self.position = Rotation.rotate(Rotation.CLOCKWISE, self.position)
    self._direction = Direction.right(self._direction)
