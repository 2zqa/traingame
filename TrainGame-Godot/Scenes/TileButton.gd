# Displays a single tile of the given object
tool

signal pressed_tile_id  # Fired when pressed, supplies one argument: the tile id

extends TextureButton

export(TileSet) var tile_set: TileSet setget _set_tile_set
export(int) var tile_id setget _set_tile_id


func _init():
    self._update_texture()

func _set_tile_set(value: TileSet) -> void:
    tile_set = value
    self._update_texture()


func _set_tile_id(value: int) -> void:
    tile_id = value
    self._update_texture()


func _update_texture() -> void:
    if self.tile_set == null:
        self.texture_normal = null
        return
    var texture = self.tile_set.tile_get_texture(self.tile_id)
    var texture_region = self.tile_set.tile_get_region(self.tile_id)
    var atlas_texture = AtlasTexture.new()
    atlas_texture.atlas = texture
    atlas_texture.region = texture_region
    self.texture_normal = atlas_texture


# Forwards with the tile_id argument included.
func _on_SingleTileDisplay_pressed() -> void:
    emit_signal("pressed_tile_id", self.tile_id)
