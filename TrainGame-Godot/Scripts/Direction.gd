class_name Direction

const EAST = 0
const SOUTH = 1
const WEST = 2
const NORTH = 3

# The four cardinal directions
const NORTH_EAST_SOUTH_WEST = PoolIntArray([NORTH, EAST, SOUTH, WEST])


# Gets the direction left to the given direction. So SOUTH becomes EAST.
static func left(direction: int) -> int:
    if direction == 0:
        return 3
    return direction - 1


# Gets the direction right to the given direction. So SOUTH becomes WEST.
static func right(direction: int) -> int:
    if direction == 3:
        return 0
    return direction + 1


# Gets the direction opposite to the given direction. So SOUTH becomes NORTH.
static func opposite(direction: int) -> int:
    if direction == EAST:
        return WEST
    if direction == WEST:
        return EAST
    if direction == NORTH:
        return SOUTH
    if direction == SOUTH:
        return NORTH
    push_error("Invalid direction in opposite(...): " + str(direction))
    return -1


# Gets the directions left, right and opposite to the given direction, in that
# order.
static func left_right_opposite(direction: int) -> PoolIntArray:
    return PoolIntArray([left(direction),
                         right(direction),
                         opposite(direction)])


# Gets a vector of length one pointing in the given direction. Returns (-1, -1)
# if an invalid direction has been given.
static func to_vector(direction: int) -> Vector2:
    if direction == EAST:
        return Vector2(1, 0)
    elif direction == SOUTH:
        return Vector2(0, 1)
    elif direction == WEST:
        return Vector2(-1, 0)
    elif direction == NORTH:
        return Vector2(0, -1)
    else:
        push_error("Invalid direction in to_vector(...): " + str(direction))
        return Vector2(-1, -1)
    
