extends TileMap

var tiles_health = {}  # Dictionary to store health of tiles
var max_tile_health = 100  # Max health for a tile

 
func break_tile(posn: Vector2, damage: int):
	var tile_position := world_to_map(posn)
	if get_cellv(tile_position) == INVALID_CELL:
		return
	if tiles_health.has(tile_position):
		tiles_health[tile_position] -= damage
		if tiles_health[tile_position] <= 0:
			set_cellv(tile_position, -1)
			tiles_health.erase(tile_position)
	else:
		tiles_health[tile_position] = max_tile_health - damage

	$HealthBars.update()

