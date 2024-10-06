extends Node2D



func _draw():
	var tiles_health = get_parent().tiles_health
	var max_tile_health = get_parent().max_tile_health
	# Draw health bars for all tiles being damaged
	for tile_position in tiles_health.keys():
		var health_percent = float(tiles_health[tile_position]) / max_tile_health
		var world_position = get_parent().map_to_world(tile_position)
		var bar_width = 64  # Width of the health bar
		var bar_height = 8  # Height of the health bar
		var bar_color = Color(1, 0, 0)  # Red health bar
		draw_rect(Rect2(world_position, Vector2(bar_width * health_percent, bar_height)), bar_color)
