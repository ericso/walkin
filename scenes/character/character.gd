extends Node2D

@export var STEP_DISTANCE := 32        # Distance moved per step
@export var STEP_DURATION := 0.2       # Time it takes to move per step

@onready var sprite := $Sprite         # Your AnimatedSprite2D node

var is_stepping := false               # Block re-stepping mid-animation

func step_forward():
	if is_stepping:
		return

	is_stepping = true

	# Start animation
	sprite.frame = 0
	sprite.play("walk")  # Ensure 'walk' animation has Loop OFF

	# Connect to animation_finished (connect only once)
	if not sprite.is_connected("animation_finished", Callable(self, "_on_anim_finished")):
		sprite.connect("animation_finished", Callable(self, "_on_anim_finished"))
	
	# Start movement tween
	var target = position + Vector2(STEP_DISTANCE, 0)
	var tween = create_tween()
	tween.tween_property(self, "position", target, STEP_DURATION)
	tween.tween_callback(Callable(self, "_on_step_finished"))

func _on_anim_finished():
	# Optional: hold on last frame or reset to frame 0
	sprite.frame = sprite.frame_count - 1

func _on_step_finished():
	is_stepping = false
