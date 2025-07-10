extends Node

class Upgrade:
	var id: String
	var name: String
	var cost: int
	var unlocked: bool = false

var upgrades := {}

signal upgrade_unlocked(upgrade_id: String)

func _ready():
	upgrades["bike"] = Upgrade.new()
	upgrades["bike"].id = "bike"
	upgrades["bike"].name = "Bicycle"
	upgrades["bike"].cost = 10000 # 10,000 steps (5 miles)
	upgrades["bike"].unlocked = false
	

	upgrades["car"] = Upgrade.new()
	upgrades["car"].id = "car"
	upgrades["car"].name = "Car"
	upgrades["car"].cost = 200000 # 200,000 steps (100 miles)
	upgrades["car"].unlocked = false

# TODO figure out a better way of handling unlocks
func check_unlocks():
	if StepTracker.get_step_count() >= upgrades["bike"].cost and not upgrades["bike"].unlocked:
		upgrades["bike"].unlocked = true
		emit_signal("upgrade_unlocked", "bike")
		SaveManager.save()
	
	if StepTracker.get_step_count() >= upgrades["car"].cost and not upgrades["car"].unlocked:
		upgrades["car"].unlocked = true
		emit_signal("upgrade_unlocked", "car")
		SaveManager.save()

func get_unlocked_upgrades() -> Array:
	var unlocked = []
	for key in upgrades:
		if upgrades[key].unlocked:
			unlocked.push_back(key)
	return unlocked

func set_unlocked_upgrades(unlocks: Array) -> void:
	for key in unlocks:
		if upgrades.has(key):
			upgrades[key].unlocked = true
