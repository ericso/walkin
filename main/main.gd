extends Node2D

@onready var character = $Character
@onready var camera = $Camera
@onready var step_label = $UI/StepLabel

var step_count := 0

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		character.step_forward()
		step_count += 1
		step_label.text = "Steps: %d" % step_count

func _process(_delta):
	camera.position.x = character.position.x + 200  # keep camera ahead of player
