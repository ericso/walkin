extends Node2D

@onready var character = $Character
@onready var camera = $Camera
@onready var step_label = $UI/StepLabel

# TODO these labels are temporary and for testing
@onready var bike_label = $UI/BikeLabel
@onready var car_label = $UI/CarLabel

func _ready():
	StepTracker.steps_updated.connect(_on_steps_updated)
	_hide_all_labels()
	SaveManager.load()
	
	# TODO this is visualization for testing, remove 
	var unlocked := UpgradeManager.get_upgrade_unlock_status()
	for id in unlocked:
		match id:
			"bike":
				bike_label.visible = unlocked[id]
			"car":
				car_label.visible = unlocked[id]
	
func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		character_takes_steps(1)

func _process(delta: float):
	# keep camera ahead of player
	camera.position.x = character.position.x + 200
	
	# character steps
	character_takes_steps(StepTracker.calculate_step_delta(delta))

func _on_steps_updated(_new_total: int):
	step_label.text = StepTracker.get_steps_label()

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		SaveManager.save()

func _hide_all_labels() -> void:
	bike_label.visible = false
	car_label.visible = false

# character_takes_steps handles the character taking `steps` steps
func character_takes_steps(steps: float) -> void:
	if steps > 0:
		character.step_forward()
	StepTracker.add_steps(steps)
