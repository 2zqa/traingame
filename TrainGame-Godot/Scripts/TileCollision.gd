# Used to set tile collisions.
class_name TileCollision

var Rotation = preload("res://Scripts/Rotation.gd")

var _lines: Array
var _size: Vector2
var _origin: Vector2

# Creates a tile collision map. collision_map must be a string like "XO X.". Here,
# the O indicates the origin of the object, X indicates additional tiles that are
# blocked off, . indicates free space and a " " starts a new line.
func _init(collision_map: String):
    var lines = collision_map.split(" ")
    self._lines = Array()
    self._origin = Vector2(0, 0)
    
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
    push_error("Unknown rotation: " + str(rotation))
    return false    

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
            value += " "
        else:
            first = false
        for i in range(line.size()):
            if i == self._origin.x and line_number == self._origin.y:
                value += "O"  # We're at the origin
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
    var line: PoolByteArray = self._lines[tile_pos.y]
    if tile_pos.x >= line.size():
        return false
    return line[tile_pos.x] == 1
