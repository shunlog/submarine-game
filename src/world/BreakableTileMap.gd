tool
extends TileMap
class_name BreakableTilemap

signal tile_broken(tile_id)

var tiles_health = {}  # Dictionary to store health of tiles

## Run all the generation layers,
## assuming they are the nodes following the first child
export(bool) var generate setget set_generate
func set_generate(value):
	if value:  # When toggled, call the function
		var c = get_children()
		for i in range(1, c.size()):
			var n = c[i]
			var orig = n.replace
			n.replace = true if i > 1 else false
			n.generate = true
			n.replace = orig
		generate = false  # Reset the button

 
func break_tile(posn: Vector2, damage: int):
	posn = to_local(posn)
	var tile_position := world_to_map(posn)
	if get_cellv(tile_position) == INVALID_CELL:
		# try again, but move the point by 1 pixel
		# because the RayCast2D will collide outside the tile_id on its right and bottom edges
		posn += Vector2(-1, -1)
		tile_position = world_to_map(posn)
	if get_cellv(tile_position) == INVALID_CELL:
		return
	
	var tile_id := get_cellv(tile_position)
	
	if tiles_health.has(tile_position):
		tiles_health[tile_position] -= damage
		if tiles_health[tile_position] <= 0:
			set_cellv(tile_position, -1)
			tiles_health.erase(tile_position)
			emit_signal("tile_broken", tile_id)
	else:
		var init_dur = TileData.get_durability(tile_id)
		tiles_health[tile_position] = init_dur - damage

	$HealthBars.update()

