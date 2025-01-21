extends CanvasLayer

signal unpause()

func _input(event):
	if event.is_action_pressed("pause") and get_tree().paused:
		emit_signal("unpause")
		get_tree().set_input_as_handled()
