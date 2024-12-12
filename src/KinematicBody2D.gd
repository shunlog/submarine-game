extends KinematicBody2D

signal break_tile(posn, damage)

var max_speed = 300  # px/s
var acceleration = 20  # px/s gained every second
var friction = 8  # px/s lost every second in water
var gravity_accel = 15  # px/s gained every second outside water

var velocity = Vector2.ZERO  # Player's velocity


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			$RayCast2D.enabled = event.pressed

	
	
func _physics_process(delta):
	var accel := Vector2.ZERO
	
	var dirn := Vector2.ZERO
	if Input.is_action_pressed("right"):
		dirn.x += 1
	if Input.is_action_pressed("left"):
		dirn.x -= 1
	if Input.is_action_pressed("down"):
		dirn.y += 1
	if Input.is_action_pressed("up"):
		dirn.y -= 1
	accel += dirn.normalized() * acceleration
	
	var underwater := position.y > 0
	if underwater:
		velocity += accel
		velocity = velocity.move_toward(Vector2.ZERO, friction)
	else:
		velocity += Vector2(0, gravity_accel)
	
	velocity = velocity.clamped(max_speed)

	# Move the player with KinematicBody2D's move_and_slide method
	velocity = move_and_slide(velocity)
	
		
