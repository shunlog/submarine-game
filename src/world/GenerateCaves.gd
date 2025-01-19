tool 
extends Node2D

# Adds a property in the Inspector
export(bool) var generate setget set_generate
export(bool) var clear setget set_clear

func set_generate(value):
	if value:  # When toggled, call the function
		generate_tiles()
		generate = false  # Reset the button


func set_clear(value):
	if value:  # When toggled, call the function
		clear()
		clear = false  # Reset the button


export var width = 100       # Width of the tilemap in tiles
export var height = 300       # Height of the tilemap in tiles
export var tile = 1
export var replace := false
#export var min_treshold = 0.0

export var noise_seed := 0
export var noise_period := 10.0
export var noise_octaves := 3
export var noise_lacunarity := 2.0
export var noise_persistence := 0.5
export var density_gradient :Curve= Curve.new()

func _ready():
	density_gradient.min_value = -1


func gen_image(noise: OpenSimplexNoise, sprite_node: Sprite):
	var img :Image= noise.get_image(width, height)
	# Create texture from the image
	var texture = ImageTexture.new()
	texture.create_from_image(img)
	sprite_node.texture = texture


func generate_tiles():
	var noise = OpenSimplexNoise.new()
	noise.period = noise_period
	noise.octaves = noise_octaves
	noise.lacunarity = noise_lacunarity
	noise.persistence = noise_persistence
	noise.seed = noise_seed

	var tilemap: TileMap = get_parent()
#	gen_image(noise, tilemap.find_node('Sprite'))
	
	var rng = RandomNumberGenerator.new()
	rng.seed = 1234
	
	for y in range(height):
		var y_ratio :float= float(y) / height
		for x in range(width):
			# Get noise value for each tile position
			var noise_value = noise.get_noise_2d(x, y)
			# the threshold is the oposite of the curve value (for convenience)
			var min_treshold = -density_gradient.interpolate(y_ratio)
			
			if replace:
				if tilemap.get_cell(x, y) == tilemap.INVALID_CELL:
					continue
				if noise_value > min_treshold:
					tilemap.set_cell(x, y, tile)
			else:
				if noise_value > min_treshold:
					tilemap.set_cell(x, y, tile)
				elif not replace:
					tilemap.set_cell(x, y, -1)



func clear():
	var tilemap: TileMap = get_parent()
	tilemap.clear()
