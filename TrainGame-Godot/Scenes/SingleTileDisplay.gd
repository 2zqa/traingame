# Displays a single tile from a tile set at the given size
tool

extends Node2D

var TYPE_NAME = "SingleTileDisplay"  # Used by other classes for type checks

export(TileSet) var tile_set: TileSet setget _set_tile_set
export(Vector2) var size: Vector2 = Vector2(64, 64) setget _set_size
export(int) var tile_id setget _set_tile_id
export(bool) var transposed setget _set_transposed
export(bool) var x_flipped setget _set_x_flipped
export(bool) var y_flipped setget _set_y_flipped

func is_canvas_position_inside(position: Vector2) -> bool:
    # Returns true if the given position falls inside the rectangular area where this tile draws.
    return self.is_local_position_inside(self.make_canvas_position_local(position))

func is_local_position_inside(position: Vector2) -> bool:
    # Returns true if the given position falls inside the rectangular area where this tile draws.
    if position.x < 0 or position.y < 0:
        return false
    if position.x > self.size.x or position.y > self.size.y:
        return false
    return true

func _set_tile_set(value: TileSet) -> void:
    tile_set = value
    self.update()
    
func _set_size(value: Vector2) -> void:
    size = value
    self.update()

func _set_tile_id(value: int) -> void:
    tile_id = value
    self.update()

func _set_transposed(value: bool) -> void:
    transposed = value
    self.update()

func _set_x_flipped(value: bool) -> void:
    x_flipped = value
    self.update()
    
func _set_y_flipped(value: bool) -> void:
    y_flipped = value
    self.update()

func _draw():
    if self.tile_set == null:
        return
    if self.tile_id < 0 or self.tile_id >= self.tile_set.get_last_unused_tile_id():
        return

    var texture = tile_set.tile_get_texture(tile_id)
    var texture_region = tile_set.tile_get_region(tile_id)
    var draw_region = Rect2(Vector2(0, 0), self.size)
    
    var aspect_ratio = self.size.x / self.size.y
    var texture_aspect_ratio = texture_region.size.x / texture_region.size.y
    if texture_aspect_ratio < aspect_ratio:
        # Boxes left and right: add margins left and right
        var draw_region_width = self.size.y * texture_aspect_ratio
        draw_region = Rect2(Vector2((self.size.x - draw_region_width) / 2, 0), Vector2(draw_region_width, self.size.y))
    else:
        # Boxes above and below
        var draw_region_height = self.size.x / texture_aspect_ratio
        draw_region = Rect2(Vector2(0, (self.size.y - draw_region_height) / 2), Vector2(self.size.x, draw_region_height))
    
    if self.x_flipped:
        draw_region.size.x = -draw_region.size.x
    if self.y_flipped:
        draw_region.size.y = -draw_region.size.y

    self.draw_texture_rect_region(texture, draw_region,
            texture_region, Color(1, 1, 1, 1), self.transposed)
