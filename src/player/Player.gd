extends KinematicBody2D

signal break_tile(posn, damage)

var max_speed = 2000  # px/s
var accel_fraction = 0.07  # fraction of the max_speed gained every frame on move
var friction = .05  # fraction of velocity lost every frame in water
var gravity_accel = 15  # px/s gained every second outside water

var velocity := Vector2.ZERO  # Player's velocity
onready var sprite : Sprite = $Sprite

export var sonar_color : Color

var sonar := false
func toggle_sonar(v: bool = !sonar):
	sonar = v
	if v:
		$ShadowLight.color = sonar_color
		$ShadowLight.shadow_enabled = false
	else:
		$ShadowLight.color = Color.white
		$ShadowLight.shadow_enabled = true


func set_speed(v: float):
	print(v)


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			$RayCast2D.enabled = event.pressed
	elif event.is_action_pressed("sonar"):
		toggle_sonar()


func _physics_process(delta):
	var move_accel = max_speed * accel_fraction  # px/s gained every second
	var force := Vector2.ZERO
	
	var dirn := Vector2.ZERO
	if Input.is_action_pressed("right"):
		dirn.x += 1
	if Input.is_action_pressed("left"):
		dirn.x -= 1
	if Input.is_action_pressed("down"):
		dirn.y += 1
	if Input.is_action_pressed("up"):
		dirn.y -= 1
	force += dirn.normalized() * move_accel
	if dirn.x == -1:
		sprite.flip_h = true
	elif dirn.x == 1:
		sprite.flip_h = false
	
	var underwater := position.y > 10
	if underwater:
		velocity += force
		velocity -= velocity * friction
		# velocity = velocity.move_toward(Vector2.ZERO, friction)
	else:
		velocity += Vector2(0, gravity_accel)
	
	velocity = velocity.clamped(max_speed)
	
	# Move the player with KinematicBody2D's move_and_slide method
	velocity = move_and_slide(velocity)


func _on_Area2DRadar_area_entered(area: Area2D):
	# Assuming the Area2D is a child of the enemy with a "target" method
	var actor = area.get_parent()
	actor.target(self)
