extends Area2D

func _physics_process(delta):
	var areas = get_overlapping_areas()
	for a in areas:
		var parent = a.get_parent()
		if parent.is_in_group("enemies"):
			parent.hurt(1)
