extends Node2D

const ObjectsTileMap = preload("res://Scenes/ObjectsTileMap.gd")
const GroundTileMap = preload("res://Scenes/GroundTileMap.gd")

var selected_option: GroundTile
var input_disable_once: bool  # When the material is changed, this is set to true, so that we don't immediately place a material when the popup is closed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    self.selected_option = null
    self.input_disable_once = false


func place(canvas_position: Vector2) -> void:


    if self.selected_option is GroundTile:
        var tilemap_grounds: GroundTileMap = $GroundTileMap
        var ground_pos = tilemap_grounds.mouse_viewport_to_tile_pos(canvas_position)
        tilemap_grounds.set_tile(ground_pos, self.selected_option)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass
         
    
func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseButton or event is InputEventScreenDrag\
            or (event is InputEventMouseMotion and event.get_button_mask() != 0):
        place(event.position)
        self.get_tree().set_input_as_handled()
    

func _on_SideMenu_option_selected(selected_option: GroundTile):
    self.selected_option = selected_option
    self.input_disable_once = true