# Used to set tile collisions.
extends Reference
class_name TileCollision

var _lines: Array
var _size: Vector2
var _origin: Vector2
var _rotation_offset: Vector2

# Creates a tile collision map. collision_map must be a string like "XO\nX.". The
# following symbols are supported:
#   O indicates the origin of the object
#   d also indicates the origin of the object, but the rotation origin is at the top right of the tile, instead of the center.
#   ^ also indicates the origin of the object, but the rotation origin is at the top center of the tile.
#   X indicates additional tiles that are blocked off
#   . indicates free space 
#   \n starts a new line
func _init(collision_map: String):
    var lines = collision_map.split("\n")
    self._lines = Array()
    self._origin = Vector2(0, 0)
    self._rotation_offset = Vector2(0, 0)
    
    var line_number = 0
    for line in lines:
        var parsed = PoolByteArray()
        for i in range(line.length()):
            var letter = line.substr(i, 1)
            if letter == ".":
                parsed.append(0)
            elif letter == "X":
                parsed.append(1)
            elif letter == "O":
                parsed.append(1)
                self._origin = Vector2(i, line_number)
            elif letter == "d":
                parsed.append(1)
                self._origin = Vector2(i, line_number)
                self._rotation_offset = Vector2(0.5, -0.5)
            elif letter == "^":
                parsed.append(1)
                self._origin = Vector2(i, line_number)
                self._rotation_offset = Vector2(0, -0.5)
            else:
                push_error("Invalid letter: " + letter + " (" + collision_map + ")")
        self._lines.append(parsed)
        line_number += 1
 
    # Calculate size   
    var height = self._lines.size()
    var width = self._lines[0].size()
    self._size = Vector2(width, height)
    for line in self._lines:
        if line.size() != width:
            push_error("Found line with a width that is unusual")
 
# Gets the size of the used collision map.
func size() -> Vector2:
    return self._size

# Checks if there is a collision at the relative tile coordinates.
func collides(rotation: int, tile_dx: int, tile_dy: int) -> bool:
    var unrotated = Rotation.unrotate(rotation, Vector2(tile_dx, tile_dy))

    return self._collides_without_rotation(unrotated) 

# Most objects rotate around a single tile (their origin), "  O--" becomes "--O  " with a rotation of 180 degrees.
# However, sometimes you want to rotate around a position in between tiles, for example "   OP--" becomes " --dO  "
# instead of "--dO   " (note the amount of spaces). In that case you need a rotation offset. This rotation offset
# depends on whether we are starting from 0 and 180 degrees, or 90 and 270 degrees.
func get_rotation_offset(rotation: int) -> Vector2:
    return Rotation.rotate(rotation, self._rotation_offset)

# Gets the origin, rotated to the given rotation.
func get_origin(rotation: int) -> Vector2:
    return Rotation.rotate(rotation, self._origin)

# Gets a list of all positions occupied by this collision shape
func get_occupied_positions(rotation: int) -> PoolVector2Array:
    var array = PoolVector2Array()

    for y in range(self._size.y):
        var line = self._lines[y]
        for x in range(self._size.x):
            if line[x] != 0:
                var unrotated = Vector2(x, y) - self._origin
                array.append(Rotation.rotate(rotation, unrotated))
    return array


# Gets the string representation of this collision using . and X, and rows separated with a space.
func to_string() -> String:
    var value = ""
    var first = true
    
    for line_number in range(self._lines.size()):
        var line = self._lines[line_number]
        if not first:
            value += "\n"
        else:
            first = false
        for i in range(line.size()):
            if i == self._origin.x and line_number == self._origin.y:
                # We're at the origin
                if self._rotation_offset_to_origin.x != 0:
                    value += "d"  # We're using a rotation offset
                elif self._rotation_offset_to_origin.y != 0:
                    value += "^"  # We're using another ortation offset
                else:
                    value += "O"  # Not using a rotation offset
            elif line[i] == 0:
                value += "."
            else:
                value += "X"
    return value

func _collides_without_rotation(tile_pos: Vector2) -> bool:  
    tile_pos += self._origin

    if tile_pos.x < 0:
        return false
    if tile_pos.y < 0 or tile_pos.y >= self._lines.size():
        return false
    var line: PoolByteArray = self._lines[floor(tile_pos.y)]
    if tile_pos.x >= line.size():
        return false
    return line[floor(tile_pos.x)] == 1
