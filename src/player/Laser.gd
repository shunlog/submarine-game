extends RayCast2D


var collision_pos := Vector2.ZERO

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			self.enabled = event.pressed


func _physics_process(_delta):
	var mouse_position = get_local_mouse_position()
	var relative_position = mouse_position
	cast_to = relative_position.limit_length(500)
	
	if is_colliding():
		collision_pos = get_collision_point()
#		get_parent().emit_signal("break_tile", collision_pos, 10)
		var tilemap = get_parent().BreakableTilemap
		if tilemap:
			tilemap.break_tile(collision_pos, 10)
		$HitBox.global_position = collision_pos
		$HitBox.monitoring = true
		_update_hitbox()
		$Beam.visible = true
		$Beam.global_position = collision_pos
		$Beam.rotation =  PI + global_position.angle_to_point(collision_pos)
		update()
	else:
		$HitBox.monitoring = false
		$Beam.visible = false
		

func _update_hitbox():
	## should be called in _physics_process
	var areas = $HitBox.get_overlapping_areas()
	for a in areas:
		var parent = a.get_parent()
		if parent.is_in_group("enemies"):
			parent.hurt(1)


func _draw():
	if is_colliding():
		draw_line(position, to_local(collision_pos),
		 Color(1, 0, 0), 4.0)
