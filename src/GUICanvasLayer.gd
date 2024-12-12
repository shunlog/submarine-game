extends CanvasLayer

var showing := false

func _input(event):
	if event.is_action_pressed("pause"):
		toggle()
	
func toggle():
	showing = !showing
	if showing:
		get_tree().paused = true
		show()
	else:
		get_tree().paused = false
		hide()
