extends Sprite

export var LightTexture : StreamTexture

export var fog_width = 400
export var fog_height = 800

var fogImage := Image.new()
var fogTexture := ImageTexture.new()
var visited := {}
onready var lightImage : Image = LightTexture.get_data()
onready var light_offset = Vector2(
	LightTexture.get_width()/2.0, 
	LightTexture.get_height()/2.0)
	
func _ready():
	fogImage.create(fog_width, fog_height, false, Image.FORMAT_RGBAH)
	fogImage.fill(Color.black)
	fogTexture.create_from_image(fogImage)
	lightImage.convert(Image.FORMAT_RGBAH)
	texture = fogTexture


## To minimize the number of times the fog is cleared,
## We will snap the input global_pos to a grid with the size grid_size.
## We will also memorize positions that were already cleared.
## To avoid thin strips of uncleared fog,
## the grid_size shouldn't be a multiple of the circle size.
export var grid_size := 8
func update_fog(global_pos: Vector2):
	var local_pos := to_local(global_pos)
	var grid_pos := (local_pos / grid_size).round()
	
	if grid_pos in visited:
		return
	visited[grid_pos] = true
	
	var snapped_pos := grid_pos * grid_size
	fogImage.lock()
	lightImage.lock()
	var light_rect = Rect2(Vector2.ZERO, Vector2(lightImage.get_width(), lightImage.get_height()))
	fogImage.blend_rect(lightImage, light_rect, snapped_pos - light_offset)
	fogImage.unlock()
	lightImage.unlock()
	fogTexture.set_data(fogImage)
