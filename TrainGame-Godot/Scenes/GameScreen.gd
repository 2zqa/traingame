extends Node2D

const ObjectsTileMap = preload("res://Scenes/ObjectsTileMap.gd")
const GroundTileMap = preload("res://Scenes/GroundTileMap.gd")

const WORLD_RECTANGLE := Rect2(Vector2(-100, -100), Vector2(201, 201))


var selected_option: InteractOption  # GroundTile or ObjectTile

var _previous_touch_pos: Dictionary

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    self._previous_touch_pos = Dictionary()
    self.selected_option = InteractOption.new("move")
    
    WorldPopulator.populate(WORLD_RECTANGLE, $World/ObjectsTileMap, $World/GroundTileMap)

# Places the current tile at the given canvas position
func place(canvas_position: Vector2, overwrite_objects: bool = false) -> void:
    if self.selected_option.ground_tile != null:
        var tilemap_grounds: GroundTileMap = $World/GroundTileMap
        var tile_pos = tilemap_grounds.viewport_pos_to_tile_pos(canvas_position)
        if self._is_in_bounds(tile_pos):
            tilemap_grounds.set_tile(tile_pos, self.selected_option.ground_tile)
    if self.selected_option.object_tile != null:
        var tilemap_objects: ObjectsTileMap = $World/ObjectsTileMap
        var tile_pos = tilemap_objects.viewport_pos_to_tile_pos(canvas_position)
        if self._is_in_bounds(tile_pos):
            tilemap_objects.set_tile(tile_pos, self.selected_option.object_tile, overwrite_objects)

func _is_in_bounds(tile_pos: Vector2) -> bool:
    return WORLD_RECTANGLE.has_point(tile_pos)

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
    if (event is InputEventMouseButton and event.button_index == BUTTON_LEFT) \
            or event is InputEventScreenDrag\
            or (event is InputEventMouseMotion and event.get_button_mask() != 0):
        var pointer_id = Global.Mouse.get_pointer_id(event)
        var previous_position = self._previous_touch_pos.get(pointer_id)
        if previous_position != null and \
                (event is InputEventScreenDrag or event is InputEventMouseMotion):
            self.place_interpolated(previous_position, event.position)
        else:
            self.place(event.position, event.is_pressed())
        
        # Record position
        if event is InputEventMouseMotion or event is InputEventScreenDrag:
            self._previous_touch_pos[pointer_id] = event.position
        else:
            self._previous_touch_pos.erase(pointer_id)
        self.get_tree().set_input_as_handled()


func _input(event: InputEvent) -> void:
    if (event is InputEventScreenTouch and not event.is_pressed()) or \
            Global.Mouse.is_left_released(event):
        # Finger released, clear previous position
        self._previous_touch_pos.erase(Global.Mouse.get_pointer_id(event))
        var objects = $World/ObjectsTileMap
        var tile_pos = objects.mouse_event_to_tile_pos(event)
        var tile = objects.get_tile(tile_pos)
        print(tile_pos, ": ", tile.name_id, " ", Rotation.to_string(tile.rotation))


func _on_SideMenu_option_selected(selected_option: InteractOption) -> void:
    self.selected_option = selected_option
    $WorldCamera.active = selected_option.move


func _on_SideMenu_rotation_requested() -> void:
    $World/GroundTileMap.rotate_clockwise()
    $World/ObjectsTileMap.rotate_clockwise()
