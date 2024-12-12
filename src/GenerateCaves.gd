tool 
extends Node2D

# Adds a property in the Inspector
export(bool) var call_function setget set_call_function

func set_call_function(value):
	if value:  # When toggled, call the function
		generate_tiles()
		call_function = false  # Reset the button


var noise = OpenSimplexNoise.new()  # Create the noise generator

# Parameters for noise and tilemap
export var tile = 1
export var replace := false
export var width = 50       # Width of the tilemap in tiles
export var height = 50       # Height of the tilemap in tiles
export var noise_scale = 0.1       # Noise scale
export var treshhold = 0.0
export var multiplier = 1.0


func generate_tiles():
	var tilemap: TileMap = get_parent()  # Drag your TileMap node here in the editor
	for x in range(width):
		for y in range(height):
			# Get noise value for each tile position
			var nx = x * noise_scale
			var ny = y * noise_scale
			var value = noise.get_noise_2d(nx, ny) * multiplier

			if replace:
				print()
				if tilemap.get_cell(x, y) != tilemap.INVALID_CELL \
					and value > treshhold:
					tilemap.set_cell(x, y, tile)

			elif not replace:
				if value > treshhold:
						tilemap.set_cell(x, y, tile)
				else:
					tilemap.set_cell(x, y, -1)
