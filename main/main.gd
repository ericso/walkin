extends Node2D

func _process(delta):
	$Camera.position.x += 200 * delta
