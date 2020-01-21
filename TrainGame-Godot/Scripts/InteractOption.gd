# Used to specify the current way the player interacts with the world: placing a tile, moving the view, etc.
class_name InteractOption

var ground_tile: GroundTile  # or null. Set to a value to place a ground tile.
var object_tile: ObjectTile  # or null. Set to a value to place an object tile.
var move: bool  # Set to true if the player wants to move the view
var delete: bool  # Set to true if the player wants to delete an object tile

# value must be "move", a ground tile or an object tile.
func _init(value):
    self.ground_tile = null
    self.object_tile = null
    self.move = false
    self.delete = false

    if value is GroundTile:
        self.ground_tile = value
    elif value is ObjectTile:
        self.object_tile = value
    elif value == "move":
        self.move = true
    elif value == "delete":
        self.delete = true
    else:
        push_error("Unexpected value: " + str(value))
