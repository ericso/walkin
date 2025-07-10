extends Node2D

@export var step_distance := 32  # pixels per step
@export var step_duration := 0.2  # seconds for step animation

var is_stepping := false

func step_forward():
	$AnimatedSprite2D.play("walk")

	var tween = create_tween()
	tween.tween_property(self, "position", position + Vector2(32, 0), 0.2)
	tween.finished.connect(_on_step_finished)

func _on_step_finished():
	$AnimatedSprite2D.stop()
	$AnimatedSprite2D.frame = 0
