extends RayCast2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var p := Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _process(_v):
	
	var mouse_position = get_local_mouse_position()
	var relative_position = mouse_position
	cast_to = relative_position.clamped(500)
	
	if is_colliding():
		p = get_collision_point()
		get_parent().emit_signal("break_tile", p, 10)
		update()
	
	

func _draw():
	if is_colliding():
		 # Draw a red circle at the point
		draw_circle(to_local(p), 10, Color(1, 0, 0))
		draw_line(position,to_local(p), Color(1, 0, 0))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
