class_name GroundTile

export(String) var name_id
export(int) var texture_id
const _tile_set = preload("res://TileSets/Ground.tres")

func _init(name_id: String, texture_id: int):
    self.name_id = name_id
    self.texture_id = texture_id

# Gets the texture offset in the tile set
func create_texture() -> Texture:
    var atlas = AtlasTexture.new()
    atlas.atlas = self._tile_set.tile_get_texture(self.texture_id)
    atlas.region = self._tile_set.tile_get_region(self.texture_id)
    return atlas
