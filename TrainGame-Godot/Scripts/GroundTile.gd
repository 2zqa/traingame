class_name GroundTile

const _TILE_SET := preload("res://TileSets/Ground.tres")

export(String) var name_id
export(int) var texture_id

func _init(name_id: String, texture_id: int):
    self.name_id = name_id
    self.texture_id = texture_id

# Creates the texture of this tile
func create_texture() -> Texture:
    var atlas = AtlasTexture.new()
    atlas.atlas = _TILE_SET.tile_get_texture(self.texture_id)
    atlas.region = _TILE_SET.tile_get_region(self.texture_id)
    return atlas

# Gets the name under which this tile is registered.
func to_string() -> String:
    return self.name_id


# Checks if the other ground tile is equal to this tile.
func equals(other: GroundTile) -> bool:
    return self.texture_id == other.texture_id
