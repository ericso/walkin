extends Node2D

@onready var character = $Character
@onready var camera = $Camera
@onready var step_label = $UI/StepLabel

var step_count := 0

func _ready():
	StepTracker.steps_updated.connect(_on_steps_updated)
	SaveManager.load()
	
func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		character.step_forward()
		StepTracker.add_steps(1)

func _process(_delta):
	camera.position.x = character.position.x + 200  # keep camera ahead of player

func _on_steps_updated(_new_total: int):
	step_label.text = StepTracker.get_steps_label()

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		SaveManager.save()
