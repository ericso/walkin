extends Node2D

@onready var character = $Character
@onready var camera = $Camera
@onready var step_label = $UI/StepLabel

# TODO these labels are temporary and for testing
@onready var bike_label = $UI/BikeLabel
@onready var bike_button = $UI/BikeButton
@onready var car_label = $UI/CarLabel
@onready var car_button = $UI/CarButton

# TODO move UI to a UI panel scene
func _ready():
	# connect signals
	StepTracker.steps_updated.connect(_on_steps_updated)
	UpgradeManager.upgrade_unlocked.connect(_on_upgrade_unlocked)
	UpgradeManager.upgrade_purchased.connect(_on_upgrade_purchased)
	SaveManager.load()
	
	_refresh_buttons()
	_refresh_labels()

	bike_button.pressed.connect(_purchase_upgrade.bind("bike"))
	car_button.pressed.connect(_purchase_upgrade.bind("car"))

func _purchase_upgrade(id: String) -> void:
	UpgradeManager.purchase_upgrade(id)
	
func _on_upgrade_unlocked(id: String) -> void:
	match id:
		"bike":
			bike_button.visible = true
		"car":
			car_button.visible  = true

func _on_upgrade_purchased(id: String) -> void:
	match id:
		"bike":
			bike_label.visible = true
			bike_button.visible = false
		"car":
			car_label.visible  = true
			car_button.visible  = false

# _refresh_labels sets visiblity of "purchased" labels
# they should be visible if they have been purchased
func _refresh_labels() -> void:
	bike_label.visible = UpgradeManager.purchased_upgrades.get("bike",  false)
	car_label.visible  = UpgradeManager.purchased_upgrades.get("car",   false)

# _refresh_buttons set visibility of "purchase" buttons
# they should be visible IFF they upgrade has been unlocked, but has not been purchased
func _refresh_buttons() -> void:
	bike_button.visible = UpgradeManager.unlocked_upgrades.get("bike",  false) and not UpgradeManager.purchased_upgrades.get("bike",  false)
	car_button.visible  = UpgradeManager.unlocked_upgrades.get("car",  false) and not UpgradeManager.purchased_upgrades.get("car",   false)

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


func _on_bike_button_pressed() -> void:
	pass # Replace with function body.
