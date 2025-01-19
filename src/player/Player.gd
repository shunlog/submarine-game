extends KinematicBody2D

signal break_tile(posn, damage)


export var sonar_color : Color
const accel_fraction = 0.07  # fraction of the max_speed gained every frame on move
const friction = .05  # fraction of velocity lost every frame in water
const gravity_accel = 15  # px/s gained every second outside water
const TILE_SIZE := 64

# Upgradeable sub characteristics
# These are "initial" because they can be upgraded
const initial_max_speed := 400 # px/s
const initial_max_hull := 1000  # arbitrary units
const initial_max_fuel := 1000  # arbitrary units
const initial_max_pressure := 100  # measured in blocks below the water level
var max_speed := initial_max_speed
var max_hull := initial_max_hull
var max_fuel := initial_max_fuel
var max_pressure := initial_max_pressure

# State variables
var velocity := Vector2.ZERO  # Player's velocitym
var hull := max_hull
var fuel := max_fuel
var money := 0
var sonar := false


onready var sprite := $Sprite
onready var NodeShadow := $ShadowLight
onready var LabelSpeed := $GUICanvasLayer/MarginContainer/VBoxContainer/debug/speed/LabelSpeed
onready var LabelSonar := $GUICanvasLayer/MarginContainer/VBoxContainer/debug/sonar/LabelSonar
onready var LabelFPS := $GUICanvasLayer/MarginContainer/VBoxContainer/debug/fps/LabelFPS
onready var LabelMoney := $GUICanvasLayer/MarginContainer/VBoxContainer/dashboard/money/LabelMoney
onready var ProgressBarHull := $GUICanvasLayer/MarginContainer/VBoxContainer/dashboard/hull/ProgressBarHull
onready var ProgressBarFuel := $GUICanvasLayer/MarginContainer/VBoxContainer/dashboard/fuel/ProgressBarFuel
onready var ProgressBarPressure := $GUICanvasLayer/MarginContainer/VBoxContainer/dashboard/pressure/ProgressBarPressure

func toggle_sonar(v: bool = !sonar):
	sonar = v
	LabelSonar.text = str(v)
	NodeShadow.shadow_enabled = !v
	NodeShadow.color = sonar_color if v else Color.white


## v is between 0 and 4
func set_speed(v: float):
	max_speed = initial_max_speed * (1 + 0.2 * v)


func _ready():
	toggle_sonar(false)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			$RayCast2D.enabled = event.pressed
	elif event.is_action_pressed("sonar"):
		toggle_sonar()

func _process(delta):
	_update_dashboard()

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

func _get_depth_blocks() -> float:
	return position.y / TILE_SIZE
	

func _update_dashboard():
	LabelSpeed.text = '%8.2f' % [velocity.length()]
	LabelFPS.text = str(Engine.get_frames_per_second())
	LabelMoney.text = str(money)
	ProgressBarFuel.value = fuel / max_fuel * 100
	ProgressBarHull.value = hull / max_hull * 100
	ProgressBarPressure.value = _get_depth_blocks() / max_pressure * 100
