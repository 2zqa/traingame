extends Node

# Tries to get the smallest rectangel that encloses the entire shape
func get_rectangle(shape: Shape2D) -> Rect2:
    var points = null
    if shape is ConvexPolygonShape2D:
        points = shape.points
    if shape is ConcavePolygonShape2D:
        points = shape.segments
    if points != null:
        var min_x = null
        var max_x = null
        var min_y = null
        var max_y = null
        for point in points:
            if min_x == null or point.x < min_x:
                min_x = point.x
            if max_x == null or point.x > max_x:
                max_x = point.x
            if min_y == null or point.y < min_y:
                min_y = point.y
            if max_y == null or point.y > max_y:
                max_y = point.y
        if min_x != null:
            return Rect2(min_x, min_y, max_x - min_x, max_y - min_y)
            
    # Return a default shape
    return Rect2(0, 0, 1, 1)