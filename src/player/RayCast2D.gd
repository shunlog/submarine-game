extends RayCast2D


var collision_pos := Vector2.ZERO

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			self.enabled = event.pressed


func _process(_delta):
	var mouse_position = get_local_mouse_position()
	var relative_position = mouse_position
	cast_to = relative_position.clamped(500)
	
	if is_colliding():
		collision_pos = get_collision_point()
		get_parent().emit_signal("break_tile", collision_pos, 10)
		$HitBox.global_position = collision_pos
		$HitBox.monitoring = true
		update()
	else:
		$HitBox.monitoring = false


func _draw():
	if is_colliding():
		 # Draw a red circle at the point
		draw_circle(to_local(collision_pos), 10, Color(1, 0, 0))
		draw_line(position,to_local(collision_pos), Color(1, 0, 0))
