const NONE := 0  # No rotation
const CLOCKWISE := 1  # 90 degrees clockwise
const HALF := 2  # 180 degrees
const COUNTER_CLOCKWISE := 3  # 270 degrees clockwise

# Rotations are stored as numbers; this function gets the string, which is useful for debugging.
static func to_string(rotation: int) -> String:
    if rotation == NONE:
        return "NONE"
    if rotation == CLOCKWISE:
        return "CLOCKWISE"
    if rotation == HALF:
        return "HALF"
    if rotation == COUNTER_CLOCKWISE:
        return "COUNTER_CLOCKWISE"
    return "UNKNOWN ROTATION " + str(rotation)

# Rotates a vector.
static func rotate(rotation: int, vector2: Vector2) -> Vector2:
    if rotation == NONE:
        return vector2
    if rotation == CLOCKWISE:
        return Vector2(-vector2.y, vector2.x)
    if rotation == HALF:
        return Vector2(-vector2.x, -vector2.y)
    if rotation == COUNTER_CLOCKWISE:
        return Vector2(vector2.y, -vector2.x)
    push_error("Unknown rotation: " + str(rotation))
    return vector2

# Removes the rotation of a vector. unrotate(rotate(vec)) == vec
static func unrotate(rotation: int, vector2: Vector2) -> Vector2:
    if rotation == NONE:
        return vector2
    if rotation == CLOCKWISE:
        return Vector2(vector2.y, -vector2.x)
    if rotation == HALF:
        return Vector2(-vector2.x, -vector2.y)
    if rotation == COUNTER_CLOCKWISE:
        return Vector2(-vector2.y, vector2.x)
    push_error("Unknown rotation: " + str(rotation))
    return vector2   
    