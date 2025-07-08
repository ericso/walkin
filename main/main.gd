extends Node2D

@onready var character = $Character
@onready var camera = $Camera

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		character.step_forward()

func _process(_delta):
	camera.position.x = character.position.x + 200  # keep camera ahead of player
