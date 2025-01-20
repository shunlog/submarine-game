extends KinematicBody2D

var target_node: Node2D = null
var speed = 200

func target(player):
	target_node = player
	

func _physics_process(delta):
	if target_node:
		var dir := position.direction_to(target_node.position)
		$AnimatedSprite.flip_h = dir.x < 0
		var velocity = speed * dir
		move_and_slide(velocity)

func hurt(hp):
	print("%d hurt"%[hp])
	health -= hp
	update()


const max_health = 100.0
var health = max_health

func _draw():
	var health_percent = float(health) / max_health
	var bar_width = 64.0  # Width of the health bar
	var bar_height = 8.0  # Height of the health bar
	var bar_color = Color(1, 0, 0)  # Red health bar
	draw_rect(Rect2(Vector2(-bar_width/2, -16), Vector2(bar_width * health_percent, bar_height)), bar_color)
