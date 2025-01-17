extends KinematicBody2D

var target_node: Node2D = null
var speed = 200

func target(player):
	print(player)
	target_node = player
	

func _physics_process(delta):
	if target_node:
		var dir := position.direction_to(target_node.position)
		$AnimatedSprite.flip_h = dir.x < 0
		var velocity = speed * dir
		move_and_slide(velocity)
