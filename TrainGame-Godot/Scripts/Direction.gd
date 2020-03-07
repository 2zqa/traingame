class_name Direction

const RIGHT = 0
const DOWN = 1
const LEFT = 2
const UP = 3

static func to_vector(direction: int) -> Vector2:
    if direction == RIGHT:
        return Vector2(1, 0)
    elif direction == DOWN:
        return Vector2(0, 1)
    elif direction == LEFT:
        return Vector2(-1, 0)
    elif direction == UP:
        return Vector2(0, -1)
    else:
        push_error("Invalid direction: " + str(direction))
        return Vector2(-1, -1)
    
