class_name ObjectType
extends Reference

enum Types {GROUND, SURFACE, ENTITY}

# For things like grass and sand, that are below everything else.
const GROUND = Types.GROUND
# For things like rails and roads, that lay flat on the ground,
const SURFACE = Types.SURFACE
# For things that are standing upwards.
const ENTITY = Types.ENTITY


# Returns True if the object type only holds tiles that don't change
# their texture when rotating. (Buildings do, for example.)
static func is_rotational_symmetrical(object_type: int) -> bool:
    return object_type == GROUND
