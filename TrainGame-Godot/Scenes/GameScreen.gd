extends Node2D

const _MENU_SCREEN := "res://Scenes/MainMenu/TitleScreen.tscn"

var selected_option: InteractOption

var _previous_touch_pos: Dictionary

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    self._previous_touch_pos = Dictionary()
    self.selected_option = InteractOption.new("move")
    WorldPopulator.populate($World.WORLD_RECTANGLE, $World)

    var _unused = FileIO.load_world(Global.world_save_location, $World)
    Global.paths = PathsInWorld.new($World.WORLD_RECTANGLE, $World/SurfaceTileMap, $World/GroundTileMap)
    Global.rails = RailsInWorld.new($World/SurfaceTileMap)

# Places the current tile at the given canvas position
func place(canvas_position: Vector2, overwrite_objects: bool = false) -> void:
    if self.selected_option.object_tile != null:
        var world: GameWorld = $World
        var tile_pos = world.viewport_pos_to_tile_pos(canvas_position)
        if self._is_in_bounds(tile_pos):
            world.set_tile(tile_pos, self.selected_option.object_tile, overwrite_objects)

func _is_in_bounds(tile_pos: Vector2) -> bool:
    return $World.WORLD_RECTANGLE.has_point(tile_pos)

# Places the current tile in a line of all given canvas positions
func place_interpolated(canvas_position1: Vector2, canvas_position2: Vector2) -> void:

    # When placing in a line, only overwrite existing things if we're using the eraser tool
    var overwrite = self.selected_option.erase

    if self.selected_option.object_tile != null:
        var world: GameWorld = $World
        var tile_pos1 = world.viewport_pos_to_tile_pos(canvas_position1)
        var tile_pos2 = world.viewport_pos_to_tile_pos(canvas_position2)
        var interpolation_steps = tile_pos1.distance_to(tile_pos2)
        if interpolation_steps == 0:
            # No interpolation necessary
            place(canvas_position2, overwrite)
        else:
            # Interpolate
            for i in range(interpolation_steps + 1):
                var canvas_position = canvas_position1.linear_interpolate(canvas_position2, i / interpolation_steps)
                place(canvas_position, overwrite)

func _unhandled_input(event: InputEvent) -> void:
    if (event is InputEventMouseButton and event.button_index == BUTTON_LEFT) \
            or event is InputEventScreenDrag\
            or (event is InputEventMouseMotion and event.get_button_mask() != 0):
        var pointer_id = Mouse.get_pointer_id(event)
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
            var _u = self._previous_touch_pos.erase(pointer_id)
        self.get_tree().set_input_as_handled()


func _input(event: InputEvent) -> void:
    if (event is InputEventScreenTouch and not event.is_pressed()) or \
            Mouse.is_left_released(event):
        # Finger released, clear previous position
        var _u = self._previous_touch_pos.erase(Mouse.get_pointer_id(event))
        var world: GameWorld = $World
        var tile_pos = world.mouse_event_to_tile_pos(event)
        print(tile_pos, " ground: ", world.get_tile(tile_pos, ObjectType.GROUND).to_string(),
                        " surface: ", world.get_tile(tile_pos, ObjectType.SURFACE).to_string(),
                        " entity: ", world.get_tile(tile_pos, ObjectType.ENTITY).to_string())


func _on_SideMenu_option_selected(selected_option: InteractOption) -> void:
    self.selected_option = selected_option
    $WorldCamera.active = selected_option.move


func _on_SideMenu_rotation_requested() -> void:
    $World.rotate_clockwise()

func _on_SideMenu_save_and_quit_requested() -> void:
    if FileIO.write(Global.world_save_location, $World.WORLD_RECTANGLE,
            $World/EntitiesTileMap, $World/SurfaceTileMap, $World/GroundTileMap) == OK:
        if FileIO.write_name(Global.world_save_location, Global.world_name) == OK:
            self._exit()
        else:
            push_error("Aborting world exit due to world name save failure.")
    else:
        push_error("Aborting world exit due to world data save failure.")


# Exits to the main menu without saving
func _exit():
    Global.paths = null
    Global.rails = null
    if get_tree().change_scene(_MENU_SCREEN) != OK:
        push_error("Failed to change scene")
