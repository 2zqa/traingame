# Used to specify the current way the player interacts with the world: placing a tile, moving the view, etc.
extends Reference
class_name InteractOption

var object_tile: ObjectTile  # or null. Set to a value to place an object tile.
var move: bool  # Set to true if the player wants to move the view
var erase: bool  # Set to true if the action is to erase an object

# value must be "move", "erase", a ground tile or an object tile.
func _init(value):
    self.object_tile = null
    self.move = false
    self.erase = false

    if value is ObjectTile:
        self.object_tile = value
    elif value == "move":
        self.move = true
    elif value == "erase":
        self.erase = true
        self.object_tile = Global.Registry.EMPTY  # Erasing is "placing" an empty tile
    else:
        push_error("Unexpected value: " + str(value))
