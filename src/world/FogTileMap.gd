extends TileMap

#var p: KinematicBody2D  # player
onready var p := get_tree().get_root().get_node("Node2D/Player")

func _ready():
	# it's useful to have it set to invisible in the editor
#	visible = true


func update_fog():
	# update the cells around the player
	var r = 30
	var pos = p.position / 16
	for dx in range(-r, r):
		for dy in range(-r, r):
			var dist = sqrt(dx * dx + dy * dy)
			if dist > r:
				continue
			var np = pos + Vector2(dx, dy)
			set_cellv(np, 4)
	
	
	
	
	
	
	
