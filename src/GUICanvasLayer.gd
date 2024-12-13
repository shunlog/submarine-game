extends CanvasLayer

var showing := false

func _ready():
	toggle(false)

func _input(event):
	if event.is_action_pressed("pause"):
		toggle()
	
func toggle(val=null):
	if val == null:
		showing = !showing
	else:
		showing = val
	
	if showing:
		get_tree().paused = true
		show()
	else:
		get_tree().paused = false
		hide()
