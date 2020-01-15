extends Node2D

const ObjectsTileMap = preload("res://Scenes/ObjectsTileMap.gd")
const GroundTileMap = preload("res://Scenes/GroundTileMap.gd")

var selected_option  # GroundTile or ObjectTile

var _previous_touch_pos: Dictionary

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    self.selected_option = null
    self._previous_touch_pos = Dictionary()

# Places the current tile at the given canvas position
func place(canvas_position: Vector2) -> void:
    if self.selected_option is GroundTile:
        var tilemap_grounds: GroundTileMap = $World/GroundTileMap
        var ground_pos = tilemap_grounds.viewport_pos_to_tile_pos(canvas_position)
        tilemap_grounds.set_tile(ground_pos, self.selected_option)
    if self.selected_option is ObjectTile:
        var tilemap_objects: ObjectsTileMap = $World/ObjectsTileMap
        var ground_pos = tilemap_objects.viewport_pos_to_tile_pos(canvas_position)
        tilemap_objects.set_tile(ground_pos, self.selected_option)

# Places the current tile in a line of all given canvas positions
func place_interpolated(canvas_position1: Vector2, canvas_position2: Vector2) -> void:
    var distance = canvas_position1.distance_to(canvas_position2)
    var tilemap = null
    if self.selected_option is GroundTile:
        tilemap = $World/GroundTileMap
    elif self.selected_option is ObjectTile:
        tilemap = $World/ObjectsTileMap
    
    if tilemap != null:
        var tile_pos1 = tilemap.viewport_pos_to_tile_pos(canvas_position1)
        var tile_pos2 = tilemap.viewport_pos_to_tile_pos(canvas_position2)
        var interpolation_steps = tile_pos1.distance_to(tile_pos2)
        if interpolation_steps == 0:
            # No interpolation necessary
            tilemap.set_tile(canvas_position2, self.selected_option)
        else:
            # Interpolate
            for i in range(interpolation_steps + 1):
                var tile_pos = tile_pos1.linear_interpolate(tile_pos2, i / interpolation_steps)
                tilemap.set_tile(tile_pos, self.selected_option)
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
        print(objects.get_tile(objects.mouse_event_to_tile_pos(event)).name_id)
    

func _on_SideMenu_option_selected(selected_option):
    self.selected_option = selected_option