extends Node2D

func _process(_delta):
	$Fog.update_fog($Player.global_position)
