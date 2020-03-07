extends AnimatedSprite

func _process(delta: float) -> void:
    if Global.paths.is_aligned(self.position):
        # Check if we can continue
        # If not, change direction
        pass
