extends Node2D

@onready var character = $Character
@onready var camera = $Camera
@onready var ui = $UI

func _ready():
	SaveManager.load()
	ui.refresh_buttons()
	ui.refresh_labels()

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		character_takes_steps(1)

func _process(delta: float):
	camera.position.x = character.position.x + 200 # keep camera ahead of player
	character_takes_steps(StepTracker.calculate_step_delta(delta))

func _notification(what: int) -> void:
	# save game state on close request
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		SaveManager.save()

# character_takes_steps handles the character taking `steps` steps
func character_takes_steps(steps: float) -> void:
	if steps > 0:
		character.step_forward()
	StepTracker.add_steps(steps)
