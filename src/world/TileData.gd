extends Node

enum {
	DIRT, STONE, OBSIDIAN
	COAL, IRON, GOLD, REDSTONE, DIAMOND
}

## These have to match with the order of the TILE_ID's in the tileset
var _tile_names = {
	10: DIRT,
	2: STONE,
	3: COAL,
	4: IRON,
	5: GOLD,
	11: REDSTONE,
	7: DIAMOND,
	8: OBSIDIAN
}

const _default_durability := 5
var _durability = {
	DIRT: 100,
	STONE: 300,
	COAL: 350,
	IRON: 350,
	GOLD: 350,
	REDSTONE: 500,
	DIAMOND: 500,
	OBSIDIAN: 1000,
}


func get_durability(tile_id) -> int:
	if not (tile_id in _tile_names):
		return _default_durability
	var tile_name = _tile_names[tile_id]
	var dur = _durability.get(tile_name, _default_durability)
	return dur
