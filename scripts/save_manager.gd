extends Node

var SAVE_PATH := "user://save.json"

var data := {}

func save():
	data.set("steps", StepTracker.get_step_count())
	data.set("unlocked_upgrades", UpgradeManager.unlocked_upgrades)
	data.set("purchased_upgrades", UpgradeManager.purchased_upgrades)
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(data))

func load():
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	data = JSON.parse_string(file.get_as_text())
	if typeof(data) == TYPE_DICTIONARY:
		StepTracker.set_step_count(data.get("steps", 0))
		
		if data.has("unlocked_upgrades"):
			var loaded_unlocks: Dictionary[String, bool]
			for id in data["unlocked_upgrades"]:
				loaded_unlocks[id] = bool(data["unlocked_upgrades"][id])
				UpgradeManager.unlocked_upgrades = loaded_unlocks
			UpgradeManager.check_unlocks()
		
		if data.has("purchased_upgrades"):
			var loaded_purchases: Dictionary[String, bool]
			for id in data["purchased_upgrades"]:
				loaded_purchases[id] = bool(data["purchased_upgrades"][id])
				UpgradeManager.purchased_upgrades = loaded_purchases
