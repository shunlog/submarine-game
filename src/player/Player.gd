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
var speed_level := 0 setget set_speed_level  # int in range [0, 4]
var hull := max_hull
var fuel := max_fuel
var money := 600
var sonar := false


onready var sprite := $Sprite
onready var NodeShadow := $ShadowLight
onready var PauseMenu := $PauseCanvasLayer
onready var LabelSpeed := $GUICanvasLayer/MarginContainer/VBoxContainer/debug/speed/LabelSpeed
onready var LabelSonar := $GUICanvasLayer/MarginContainer/VBoxContainer/debug/sonar/LabelSonar
onready var LabelFPS := $GUICanvasLayer/MarginContainer/VBoxContainer/debug/fps/LabelFPS
onready var LabelMoney := $GUICanvasLayer/MarginContainer/VBoxContainer/dashboard/money/LabelMoney
onready var LabelEnemies := $GUICanvasLayer/MarginContainer/VBoxContainer/debug/enemies/LabelEnemies
onready var ProgressBarHull := $GUICanvasLayer/MarginContainer/VBoxContainer/dashboard/hull/ProgressBarHull
onready var ProgressBarFuel := $GUICanvasLayer/MarginContainer/VBoxContainer/dashboard/fuel/ProgressBarFuel
onready var ProgressBarPressure := $GUICanvasLayer/MarginContainer/VBoxContainer/dashboard/pressure/ProgressBarPressure
onready var ButtonSpeed = $PauseCanvasLayer/MarginContainer/Panel/MarginContainer/VBoxContainer/GridContainer/ButtonSpeed
onready var HSliderSpeed = $PauseCanvasLayer/MarginContainer/Panel/MarginContainer/VBoxContainer/GridContainer/HSliderSpeed


const speed_price = [100, 200, 300, 400]


## v is between 0 and 4
func set_speed_level(v: int):
	speed_level = v
	max_speed = initial_max_speed * (1 + 0.2 * v)
	_update_pause_menu()


func buy_speed():
	if speed_level >= speed_price.size():
		return
	if speed_price[speed_level] > money:
		return
	money -= speed_price[speed_level]
	set_speed_level(min(speed_level + 1, 4))
	_update_dashboard()



func toggle_sonar(v: bool = !sonar):
	sonar = v
	LabelSonar.text = str(v)
	NodeShadow.shadow_enabled = !v
	NodeShadow.color = sonar_color if v else Color.white

func _get_tile_price(tile_id):
	if tile_id == 3:
		return 10
	elif tile_id == 4:
		return 50
	elif tile_id == 5:
		return 100
	elif tile_id == 7:
		return 500
	else:
		return 0

func tile_broken(tile_id: int):
	money += _get_tile_price(tile_id)


func _ready():
	toggle_sonar(false)
	PauseMenu.hide()

func _input(event):
	if event.is_action_pressed("sonar"):
		toggle_sonar()

func _process(delta):
	_update_dashboard()

func _physics_process(delta):
	
	velocity = move_and_slide(velocity)
	
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
	LabelEnemies.text = str(get_tree().get_nodes_in_group("enemies").size())
	ProgressBarFuel.value = float(fuel) / max_fuel * 100
	ProgressBarHull.value = float(hull) / max_hull * 100
	ProgressBarPressure.value = _get_depth_blocks() / max_pressure * 100
	


func _update_pause_menu():
	HSliderSpeed.value = speed_level
	if speed_level >= speed_price.size():
		ButtonSpeed.text = "done"
		ButtonSpeed.disabled = true
		ButtonSpeed.pressed = false
	else:
		ButtonSpeed.text = str(speed_price[speed_level])
		
		if speed_price[speed_level] > money:
			ButtonSpeed.disabled = true
			ButtonSpeed.pressed = false
		else:
			ButtonSpeed.disabled = false
			ButtonSpeed.pressed = true
	


func _on_HurtBox_area_entered(area):
	hull -= 10
	var knockback_direction = (global_position - area.global_position).normalized()
	velocity = knockback_direction * 5000
	
	# disable hurtbox for a second
	$HurtBox.monitoring = false
	var timer = Timer.new()
	timer.wait_time = 1.0
	timer.one_shot = true
	timer.connect("timeout", self, "_on_timer_timeout")  # Connect the signal
	add_child(timer)  # Add the timer to the scene tree
	timer.start()  # Start the time
	# Pause the function until the timer times out
	yield(timer, "timeout")
	$HurtBox.monitoring = true
	
	

