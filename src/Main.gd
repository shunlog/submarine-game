extends Node2D

func _process(delta):
	$Fog.update_fog($Player.global_position)
