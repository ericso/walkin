extends Node

class Upgrade:
	var id: String # upgrade id is the same as its String key in the dictionary
	var name: String
	var cost: int # unlock threshold in steps
	var rate: float # steps per second

# upgrades is a dictionary of Upgrade class objects
var upgrades: Dictionary[String, Upgrade] = {}

# upgrade_unlock_status is a map of Upgrade IDs to a bool indicating whether or not the upgrade is unlocked
var upgrade_unlock_status: Dictionary = {}

# upgrade_purchase_status is a map of Upgrade IDs to a bool indicating whether or not the upgrade is purchased
var upgrade_purchase_status: Dictionary = {}

# monies is curreny used to purchase upgrades
var monies: int = 0

signal upgrade_unlocked(upgrade_id: String)
# TODO currently nothing sends nor consumes this signal "upgrade_purchased"
signal upgrade_purchased(upgrade_id: String)

func _ready():
	initialize_upgrades()
	initialize_upgrade_unlock_status()

func initialize_upgrade_unlock_status() -> void:
	for key in upgrades:
		upgrade_unlock_status[key] = false

func initialize_upgrade_purchase_status() -> void:
	for key in upgrades:
		upgrade_purchase_status[key] = false

# get_upgrade_unlock_status returns the dictionary of unlocked upgrades
func get_upgrade_unlock_status() -> Dictionary:
	return upgrade_unlock_status

# upgrade_purchase_status returns the dictionary of purchased upgrades
func get_upgrade_purchase_status() -> Dictionary:
	return upgrade_purchase_status

# set_upgrade_unlock_status sets the unlocked_upgrades Dictionary to the one provided
func set_upgrade_unlock_status(unlocks: Dictionary) -> void:
	upgrade_unlock_status = unlocks

# set_upgrade_unlock_status sets the unlocked_upgrades Dictionary to the one provided
func set_upgrade_purchase_status(purchased: Dictionary) -> void:
	upgrade_purchase_status = purchased

# get_step_rate returns the increase in step count rate per second for the upgrade of
# the given id
func get_step_rate(id: String) -> float:
	return upgrades[id].rate

# check_unlocks is called to see which upgrades should be currently unlocked,
# sets the status in the upgrade_unlock_status Array, and emits the signal
func check_unlocks():
	var step_count: float = StepTracker.get_step_count()
	for id: String in upgrades:
		if step_count >= upgrades[id].cost and not upgrade_unlock_status[id]:
			upgrade_unlock_status[id] = true
			# TODO currently nothing consumes this signal "upgrade_unlocked"
			emit_signal("upgrade_unlocked", id)

# initialize_upgrades builds the upgrades Dictionary
# TODO this should be loaded from a JSON or YAML file
func initialize_upgrades() -> void:
	upgrades["bike"] = Upgrade.new()
	upgrades["bike"].id = "bike"
	upgrades["bike"].name = "Bicycle"
	upgrades["bike"].cost = 10000 # 10,000 steps (5 miles)
	upgrades["bike"].rate = 2.0 # steps per second
	
	upgrades["car"] = Upgrade.new()
	upgrades["car"].id = "car"
	upgrades["car"].name = "Car"
	upgrades["car"].cost = 200000 # 200,000 steps (100 miles)
	upgrades["car"].rate = 33.3 # approx 60 MPH
