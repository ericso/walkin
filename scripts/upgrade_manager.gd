extends Node

class Upgrade:
	var id: String # upgrade id is the same as its String key in the dictionary
	var name: String
	var cost: int # unlock threshold in steps
	var rate: float # steps per second

# upgrades is a dictionary of Upgrade class objects
var upgrades: Dictionary[String, Upgrade] = {}

# unlocked_upgrades is a map of Upgrade IDs to a bool indicating whether or not the upgrade is unlocked
@export var unlocked_upgrades: Dictionary[String, bool] = {}

# purchased_upgrades is a map of Upgrade IDs to a bool indicating whether or not the upgrade is purchased
@export var purchased_upgrades: Dictionary[String, bool] = {}

# monies is curreny used to purchase upgrades
var monies: int = 0

signal upgrade_unlocked(upgrade_id: String)
# TODO currently nothing consumes this signal "upgrade_purchased"
signal upgrade_purchased(upgrade_id: String)

func _ready():
	initialize_upgrades()
	initialize_unlocks()
	initialize_purchases()

func initialize_unlocks() -> void:
	for key in upgrades:
		unlocked_upgrades[key] = false

func initialize_purchases() -> void:
	for key in upgrades:
		purchased_upgrades[key] = false

# get_step_rate returns the increase in step count rate per second for the upgrade of
# the given id
func get_step_rate(id: String) -> float:
	return upgrades[id].rate

# check_unlocks is called to see which upgrades should be currently unlocked,
# sets the status in the unlocked_upgrades Array, and emits the signal
func check_unlocks():
	var step_count: float = StepTracker.get_step_count()
	for id: String in upgrades:
		if step_count >= upgrades[id].cost and not unlocked_upgrades[id]:
			unlocked_upgrades[id] = true
			# TODO currently nothing consumes this signal "upgrade_unlocked"
			emit_signal("upgrade_unlocked", id)

func purchase_upgrade(id: String):
	purchased_upgrades[id] = true
	emit_signal("upgrade_purchased", id)
	
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
