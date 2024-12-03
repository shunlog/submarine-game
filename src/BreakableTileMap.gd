extends TileMap

var tiles_health = {}  # Dictionary to store health of tiles

func get_tile_init_health(tile: int) -> int:
	print(tile)
	# Initial health points of each tile
	if tile == 1:  # dirt
		return 150
	elif tile == 2:  # cobble
		return 200
	elif tile == 3:  # coal
		return 250
	else:
		return 300
	

 
func break_tile(posn: Vector2, damage: int):
	var tile_position := world_to_map(posn)
	if get_cellv(tile_position) == INVALID_CELL:
		# try again, but move the point by 1 pixel
		# because the RayCast2D will collide outside the tile on its right and bottom edges
		posn += Vector2(-1, -1)
		tile_position = world_to_map(posn) 
	if get_cellv(tile_position) == INVALID_CELL:
		return
	
	var tile := get_cellv(tile_position)
	
	if tiles_health.has(tile_position):
		tiles_health[tile_position] -= damage
		if tiles_health[tile_position] <= 0:
			set_cellv(tile_position, -1)
			tiles_health.erase(tile_position)
	else:
		var h = get_tile_init_health(tile)
		tiles_health[tile_position] = h - damage

	$HealthBars.update()

