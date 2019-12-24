extends Node2D

const ObjectsTileMap = preload("res://Scenes/ObjectsTileMap.gd")
const GroundTileMap = preload("res://Scenes/GroundTileMap.gd")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#     pass
    
func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseButton and event.is_pressed():
        var tilemap_objects: ObjectsTileMap = $ObjectsTileMap
        var tilemap_grounds: GroundTileMap = $GroundTileMap

        var object = tilemap_objects.get_tile(tilemap_objects.mouse_to_tile_pos(event))
        var ground = tilemap_grounds.get_tile(tilemap_grounds.mouse_to_tile_pos(event))
        print(object.name_id, " ", ground.name_id)

        self.get_tree().set_input_as_handled()

    