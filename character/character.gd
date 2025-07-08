extends Node2D

@export var step_distance := 32  # pixels per step
@export var step_duration := 0.2  # seconds for step animation

var is_stepping := false

#func step_forward():
	#if is_stepping:
		#return
	#
	#$AnimatedSprite2D.play("walk")
	#
	#is_stepping = true
	#var target_pos = position + Vector2(step_distance, 0)
	#
	#var tween = create_tween()
	#tween.tween_property(self, "position", target_pos, step_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	#tween.finished.connect(_on_step_finished)
#
#func _on_step_finished():
	#is_stepping = false
	#$AnimatedSprite2D.stop()

func step_forward():
	$AnimatedSprite2D.play("walk")

	var tween = create_tween()
	tween.tween_property(self, "position", position + Vector2(32, 0), 0.2)
	tween.finished.connect(_on_step_finished)

func _on_step_finished():
	$AnimatedSprite2D.stop()
	$AnimatedSprite2D.frame = 0
