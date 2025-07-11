extends Node

var SAVE_PATH := "user://save.json"

var data := {}

func save():
	data.set("steps", StepTracker.get_step_count())
	data.set("upgrades_unlocked", UpgradeManager.get_upgrade_unlock_status())
	data.set("upgrades_purchased", UpgradeManager.get_upgrade_purchase_status())
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(data))

func load():
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	data = JSON.parse_string(file.get_as_text())
	if typeof(data) == TYPE_DICTIONARY:
		StepTracker.set_step_count(data.get("steps", 0))
		UpgradeManager.set_upgrade_unlock_status(data.get("upgrades_unlocked", []))
		UpgradeManager.set_upgrade_purchase_status(data.get("upgrades_purchased", []))
