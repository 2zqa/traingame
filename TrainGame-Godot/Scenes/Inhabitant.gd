extends AnimatedSprite

var _direction: int = Direction.EAST
var _speed: float = 8

func _process(delta: float) -> void:
    if Global.paths == null:
        return  # Not in a world

    if Global.paths.is_aligned(self.position):
        var tile_position = Global.paths.to_tile_pos(self.position)
        var new_tile_position = tile_position + Direction.to_vector(self._direction)
        if not Global.paths.can_walk_on(new_tile_position):
            # Need to pick new direction
            for direction in Direction.left_right_opposite(self._direction):
                new_tile_position = tile_position + Direction.to_vector(direction)
                if Global.paths.can_walk_on(new_tile_position):
                    self._direction = direction
                    break

    # Move
    var direction_vector = Direction.to_vector(self._direction)
    self.position += direction_vector * self._speed * delta
    self._update_animation()


func _update_animation() -> void:
    if self._direction == Direction.NORTH:
        self.animation = "up"
    elif self._direction == Direction.EAST:
        self.animation = "right"
    elif self._direction == Direction.SOUTH:
        self.animation = "down"
    else:
        self.animation = "left"
    
