extends CanvasLayer

@onready var step_label = $StepLabel

@onready var bike_label = $BikeLabel
@onready var bike_button = $BikeButton
@onready var car_label = $CarLabel
@onready var car_button = $CarButton

func _ready():
	UpgradeManager.upgrade_unlocked.connect(_on_upgrade_unlocked)
	UpgradeManager.upgrade_purchased.connect(_on_upgrade_purchased)
	StepTracker.steps_updated.connect(_on_steps_updated)
	bike_button.pressed.connect(_purchase_upgrade.bind("bike"))
	car_button.pressed.connect(_purchase_upgrade.bind("car"))

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

func _purchase_upgrade(id: String) -> void:
	UpgradeManager.purchase_upgrade(id)

# refresh_labels sets visiblity of "purchased" labels
# they should be visible if they have been purchased
func refresh_labels() -> void:
	bike_label.visible = UpgradeManager.purchased_upgrades.get("bike", false)
	car_label.visible  = UpgradeManager.purchased_upgrades.get("car", false)

# refresh_buttons set visibility of "purchase" buttons
# they should be visible IFF they upgrade has been unlocked, but has not been purchased
func refresh_buttons() -> void:
	bike_button.visible = UpgradeManager.unlocked_upgrades.get("bike", false) \
		and not UpgradeManager.purchased_upgrades.get("bike", false)
	car_button.visible  = UpgradeManager.unlocked_upgrades.get("car", false) \
		and not UpgradeManager.purchased_upgrades.get("car", false)

func _on_steps_updated(_new_total: int):
	step_label.text = StepTracker.get_steps_label()
