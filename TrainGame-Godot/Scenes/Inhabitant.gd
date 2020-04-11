extends AnimatedSprite

var _direction: int = Direction.EAST
var _speed: float = 8
var _previous_position: Vector2

func _init() -> void:
    self._previous_position = position

func _process(delta: float) -> void:
    if Global.paths == null:
        return  # Not in a world

    if Global.paths.was_aligned(self._previous_position, self.position):
        self._teleport(Global.paths.snap_to_grid(self.position))
        self._reconsider_direction()

    # Move
    var direction_vector = Direction.to_vector(self._direction)
    self._previous_position = self.position
    self.position += direction_vector * self._speed * delta
    self._update_animation()

# Requires the inhabitant to be snapped to the grid. Changes the current direction if blocked
# or (by chance) at a T-intersection or a normal crossing.
func _reconsider_direction() -> void:
    var tile_position = Global.paths.to_tile_pos(self.position)
    var forward_tile_position = tile_position + Direction.to_vector(self._direction)
    var left_tile_position = tile_position + Direction.to_vector(Direction.left(self._direction))
    var right_tile_position = tile_position + Direction.to_vector(Direction.right(self._direction))
    var is_blocked = not Global.paths.can_walk_on(forward_tile_position)
    if is_blocked or randf() < 0.33:
        # Turn to left or right
        var left_open = Global.paths.can_walk_on(left_tile_position)
        var right_open = Global.paths.can_walk_on(right_tile_position)
        if left_open and right_open and randf() > 0.5:
            # Both left and right are possible. %0% chance to block off left
            # to force a right turn
            left_open = false 
        if left_open:
            self._direction = Direction.left(self._direction)
            is_blocked = false
        elif right_open:
            self._direction = Direction.right(self._direction)
            is_blocked = false
    if is_blocked:
        # Still blocked, reverse
        self._direction = Direction.opposite(self._direction)

func _update_animation() -> void:
    if self._direction == Direction.NORTH:
        self.animation = "up"
    elif self._direction == Direction.EAST:
        self.animation = "right"
    elif self._direction == Direction.SOUTH:
        self.animation = "down"
    else:
        self.animation = "left"

# Sets both the current and the previous position to the given value
func _teleport(position: Vector2) -> void:
    self.position = position
    self._previous_position = position
