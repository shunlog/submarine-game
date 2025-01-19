extends CanvasLayer

func _input(event):
	if event.is_action_pressed("pause"):
		var paused = get_tree().paused
		if paused:
			hide()
		else:
			get_parent()._update_pause_menu()
			show()
		get_tree().paused = !paused
