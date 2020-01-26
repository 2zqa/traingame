class_name WorldPopulator


const _TREE_AREA_WIDTH := 5

# Fillls the world with grass and trees
static func populate(world_rect: Rect2, objects: ObjectsTileMap, ground: GroundTileMap) -> void:
    var tree_offset = Vector2(_TREE_AREA_WIDTH, _TREE_AREA_WIDTH)
    var tree_rect = world_rect.grow(_TREE_AREA_WIDTH)
    var grass_rect = world_rect.grow(2)

    # Add grass
    var tile_pos = Vector2(0, 0)
    while tile_pos.x < tree_rect.size.x:
        tile_pos.y = 0
        while tile_pos.y < tree_rect.size.y:
            var world_pos = tile_pos + world_rect.position - tree_offset
            if grass_rect.has_point(world_pos):
                ground.set_tile(world_pos, Global.Registry.GRASS)
            elif int(tile_pos.x) % 2 == 0 and int(tile_pos.y) % 2 == 0:
                objects.set_tile(world_pos, Global.Registry.TREE_GROUP)
            tile_pos.y += 1
        tile_pos.x += 1
 

    # Add trees
    var x = 0
    