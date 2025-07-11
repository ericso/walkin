extends Node2D

@onready var character = $Character
@onready var camera = $Camera
@onready var step_label = $UI/StepLabel

# TODO these labels are temporary and for testing
@onready var bike_label = $UI/BikeLabel
@onready var bike_button = $UI/BikeButton
@onready var car_label = $UI/CarLabel
@onready var car_button = $UI/CarButton

func _ready():
	# connect signals
	StepTracker.steps_updated.connect(_on_steps_updated)
	UpgradeManager.upgrade_unlocked.connect(_on_upgrade_unlocked)
	SaveManager.load()
	
	_refresh_buttons()
	_refresh_labels()

func _on_upgrade_unlocked(id: String) -> void:
	print("DEBUG::_on_upgrade_unlocked id: " + id)
	match id:
		"bike":
			bike_button.visible = true
		"car":
			car_button.visible  = true

func _refresh_buttons() -> void:
	bike_label.visible = UpgradeManager.unlocked_upgrades.get("bike",  false)
	car_label.visible  = UpgradeManager.unlocked_upgrades.get("car",   false)

func _refresh_labels() -> void:
	bike_button.visible = UpgradeManager.purchased_upgrades.get("bike",  false)
	car_button.visible  = UpgradeManager.purchased_upgrades.get("car",   false)
	
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
	# save game state on close request
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		SaveManager.save()

# character_takes_steps handles the character taking `steps` steps
func character_takes_steps(steps: float) -> void:
	if steps > 0:
		character.step_forward()
	StepTracker.add_steps(steps)
