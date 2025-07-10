extends Node

class Upgrade:
	var id: String # upgrade id is the same as its String key in the dictionary
	var name: String
	var cost: int # unlock threshold in steps
	var rate: int # steps per second

# upgrades is a dictionary of Upgrade class objects
var upgrades: Dictionary[String, Upgrade] = {}

# upgrade_unlock_status is a map of Upgrade IDs to a bool indicating whether or not the upgrade is unlocked
var upgrade_unlock_status: Dictionary = {}

signal upgrade_unlocked(upgrade_id: String)

func _ready():
	initialize_upgrades()
	initialize_upgrade_unlock_status()

func initialize_upgrades() -> void:
	upgrades["bike"] = Upgrade.new()
	upgrades["bike"].id = "bike"
	upgrades["bike"].name = "Bicycle"
	upgrades["bike"].cost = 10000 # 10,000 steps (5 miles)
	upgrades["bike"].rate = 2 # steps per second
	
	upgrades["car"] = Upgrade.new()
	upgrades["car"].id = "car"
	upgrades["car"].name = "Car"
	upgrades["car"].cost = 200000 # 200,000 steps (100 miles)
	upgrades["car"].rate = 33 # approx 60 MPH

func initialize_upgrade_unlock_status() -> void:
	for key in upgrades:
		upgrade_unlock_status[key] = false

# TODO figure out a better way of handling unlocks
# check_unlocks is called to see which upgrades should be currently unlocked
func check_unlocks():
	if StepTracker.get_step_count() >= upgrades["bike"].cost and not upgrade_unlock_status["bike"]:
		upgrade_unlock_status["bike"] = true
		emit_signal("upgrade_unlocked", "bike")
	
	if StepTracker.get_step_count() >= upgrades["car"].cost and not upgrade_unlock_status["car"]:
		upgrade_unlock_status["car"] = true
		emit_signal("upgrade_unlocked", "car")

# get_upgrade_unlock_status returns the dictionary of unlocked upgrades
func get_upgrade_unlock_status() -> Dictionary:
	return upgrade_unlock_status

# set_upgrade_unlock_status sets the unlocked_upgrades Dictionary to the one provided
func set_upgrade_unlock_status(unlocks: Dictionary) -> void:
	upgrade_unlock_status = unlocks

func get_step_rate(id: String) -> int:
	return upgrades[id].rate
