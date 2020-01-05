# Displays a single tile from a tile set at the given size
tool

extends Node2D

export(TileSet) var tile_set: TileSet setget _set_tile_set
export(Vector2) var size: Vector2 = Vector2(64, 64) setget _set_size
export(int) var tile_id setget _set_tile_id
export(bool) var transposed setget _set_transposed
export(bool) var x_flipped setget _set_x_flipped
export(bool) var y_flipped setget _set_y_flipped

func _set_tile_set(value: TileSet):
    tile_set = value
    self.update()
    
func _set_size(value: Vector2):
    size = value
    self.update()

func _set_tile_id(value: int):
    tile_id = value
    self.update()

func _set_transposed(value: bool):
    transposed = value
    self.update()

func _set_x_flipped(value: bool):
    x_flipped = value
    self.update()
    
func _set_y_flipped(value: bool):
    y_flipped = value
    self.update()

func _draw():
    if self.tile_set == null:
        return
    if self.tile_id < 0 or self.tile_id >= self.tile_set.get_last_unused_tile_id():
        return

    var texture = tile_set.tile_get_texture(tile_id)
    var texture_region = tile_set.tile_get_region(tile_id)
    var draw_region = Rect2(self.position, self.size)
    if self.x_flipped:
        draw_region.size.x = -draw_region.size.x
    if self.y_flipped:
        draw_region.size.y = -draw_region.size.y

    self.draw_texture_rect_region(texture, draw_region,
            texture_region, Color(1, 1, 1, 1), self.transposed)
