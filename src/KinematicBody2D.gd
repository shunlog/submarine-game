extends KinematicBody2D

signal break_tile(posn, damage)

var speed = 400  # units/s
var acceleration = 300  # units/s
var friction = 300  # units/s

var velocity = Vector2.ZERO  # Player's velocity


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			$RayCast2D.enabled = event.pressed

	
	
func _physics_process(delta):
	var input_direction = Vector2.ZERO
	
	# Get input from arrow keys or WASD
	if Input.is_action_pressed("right"):
		input_direction.x += 1
	if Input.is_action_pressed("left"):
		input_direction.x -= 1
	if Input.is_action_pressed("down"):
		input_direction.y += 1
	if Input.is_action_pressed("up"):
		input_direction.y -= 1

	input_direction = input_direction.normalized()  # Normalize to prevent diagonal speed boost
	
	if input_direction != Vector2.ZERO:
		# Accelerate in the direction of input
		velocity = velocity.move_toward(input_direction * speed, acceleration * delta)
	else:
		# Apply friction to slow down when no input is pressed
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

	# Move the player with KinematicBody2D's move_and_slide method
	velocity = move_and_slide(velocity)
	
		
