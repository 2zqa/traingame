class_name WorldPopulator


const _TREE_AREA_WIDTH := 4

# Fills the world with grass and trees
static func populate(world_rect: Rect2, world: GameWorld) -> void:
    var tree_offset = Vector2(_TREE_AREA_WIDTH, _TREE_AREA_WIDTH)
    var tree_rect = world_rect.grow(_TREE_AREA_WIDTH)
    var no_tree_rect = world_rect.grow(2)
    var grass_rect = world_rect.grow(4)

    # Cached values (much vaster than world.set_tile()
    var entities: ObjectsTileMap = world.get_tile_map(ObjectType.ENTITY)
    var ground: ObjectsTileMap = world.get_tile_map(ObjectType.GROUND)
    var grass_id = Global.Registry.GRASS.get_texture_id()
    var tree_group_id = Global.Registry.TREE_GROUP.get_texture_id()

    # Add grass and trees
    var tile_pos = Vector2(0, 0)
    while tile_pos.x < tree_rect.size.x:
        tile_pos.y = 0
        while tile_pos.y < tree_rect.size.y:
            var world_pos = tile_pos + world_rect.position - tree_offset
            if grass_rect.has_point(world_pos):
                ground.set_cellv(world_pos, grass_id)
            if not no_tree_rect.has_point(world_pos) and int(tile_pos.x) % 2 == 0 and int(tile_pos.y) % 2 == 0:
                entities.set_cellv(world_pos, tree_group_id)
            tile_pos.y += 1
        tile_pos.x += 1
    
