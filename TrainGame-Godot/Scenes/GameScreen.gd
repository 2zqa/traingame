extends Node2D

const ObjectsTileMap = preload("res://Scenes/ObjectsTileMap.gd")
const GroundTileMap = preload("res://Scenes/GroundTileMap.gd")

var selected_option: InteractOption  # GroundTile or ObjectTile

var _previous_touch_pos: Dictionary

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    self._previous_touch_pos = Dictionary()
    self.selected_option = InteractOption.new("move")

# Places the current tile at the given canvas position
func place(canvas_position: Vector2) -> void:
    if self.selected_option.ground_tile != null:
        var tilemap_grounds: GroundTileMap = $World/GroundTileMap
        var ground_pos = tilemap_grounds.viewport_pos_to_tile_pos(canvas_position)
        tilemap_grounds.set_tile(ground_pos, self.selected_option.ground_tile)
    if self.selected_option.object_tile != null:
        var tilemap_objects: ObjectsTileMap = $World/ObjectsTileMap
        var ground_pos = tilemap_objects.viewport_pos_to_tile_pos(canvas_position)
        tilemap_objects.set_tile(ground_pos, self.selected_option.object_tile)

# Places the current tile in a line of all given canvas positions
func place_interpolated(canvas_position1: Vector2, canvas_position2: Vector2) -> void:
    var tilemap = null
    if self.selected_option.ground_tile != null:
        tilemap = $World/GroundTileMap
    elif self.selected_option.object_tile != null:
        tilemap = $World/ObjectsTileMap
    
    if tilemap != null:
        var tile_pos1 = tilemap.viewport_pos_to_tile_pos(canvas_position1)
        var tile_pos2 = tilemap.viewport_pos_to_tile_pos(canvas_position2)
        var interpolation_steps = tile_pos1.distance_to(tile_pos2)
        if interpolation_steps == 0:
            # No interpolation necessary
            place(canvas_position2)
        else:
            # Interpolate
            for i in range(interpolation_steps + 1):
                var canvas_position = canvas_position1.linear_interpolate(canvas_position2, i / interpolation_steps)
                place(canvas_position)
    else:
        place(canvas_position2)  # Cannot interpolate for this type


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass
         
    
func _unhandled_input(event: InputEvent) -> void:
    if (Global.Mouse.is_left_released(event)) \
            or event is InputEventScreenDrag\
            or (event is InputEventMouseMotion and event.get_button_mask() != 0):
        var pointer_id = Global.Mouse.get_pointer_id(event)
        var previous_position = self._previous_touch_pos.get(pointer_id)
        if previous_position != null:
            self.place_interpolated(previous_position, event.position)
        else:
            self.place(event.position)
        self._previous_touch_pos[pointer_id] = event.position
        self.get_tree().set_input_as_handled()
    
    if (event is InputEventScreenTouch and not event.is_pressed()) or \
            Global.Mouse.is_left_released(event):
        # Finger released, clear previous position
        self._previous_touch_pos.erase(Global.Mouse.get_pointer_id(event))
        var objects = $World/ObjectsTileMap
        var tile = objects.get_tile(objects.mouse_event_to_tile_pos(event))
        print(tile.name_id, " ", Rotation.to_string(tile.rotation))
    

func _on_SideMenu_option_selected(selected_option: InteractOption):
    self.selected_option = selected_option