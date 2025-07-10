extends Node

var save_path := "user://save.json"

var data := {}

func save():
	data.set("steps", StepTracker.get_step_count())
	data.set("upgrades", UpgradeManager.get_upgrade_unlock_status())
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_string(JSON.stringify(data))

func load():
	if not FileAccess.file_exists(save_path):
		return
	var file = FileAccess.open(save_path, FileAccess.READ)
	data = JSON.parse_string(file.get_as_text())
	if typeof(data) == TYPE_DICTIONARY:
		StepTracker.set_step_count(data.get("steps", 0))
		UpgradeManager.set_upgrade_unlock_status(data.get("upgrades", []))
