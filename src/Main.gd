extends Node2D

func _process(delta):
	$TransparentCanvasLayer/Fog.update_fog($Player.global_position)
