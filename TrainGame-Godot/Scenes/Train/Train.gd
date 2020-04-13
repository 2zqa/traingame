extends Node2D


var _speed: float = 20
var _direction: int = Direction.EAST
var _next_rail_tile_pos: Vector2
var _derailed: bool

# Called when the node enters the scene tree for the first time.
func _ready():
    self._derailed = false

# Finds the next track piece. Returns false if no such piece exists
func _find_next_rail() -> void:
    var tile_pos = Global.rails.to_tile_pos(self.position)
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
        print("Derailed at ", Global.rails._objects.get_tile(tile_pos).to_string())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    if Global.rails == null:
        return

    var path: Path2D = $Path2D
    if path.curve.get_point_count() < 2 and not self._derailed:
        print("Finding next rail")
        self._find_next_rail()
        return
    var path_progress: PathFollow2D = $Path2D/PathFollow2D
    path_progress.offset += _speed * delta
    if path_progress.unit_offset >= 1:
        self.position = Global.rails.to_world_pos(self._next_rail_tile_pos)
        print("End of path, moving at ", Global.rails.to_tile_pos(self.position))
        self._find_next_rail()


func _to_array(curve: Curve2D) -> PoolVector2Array:
    var array = PoolVector2Array()
    for i in range(curve.get_point_count()):
        array.append(curve.get_point_position(i))
    return array

func rotate_clockwise():
    self.position = Rotation.rotate(Rotation.CLOCKWISE, self.position)
    self._direction = Direction.right(self._direction)
