extends Node

var save_path := "user://save.json"

# --- Save to Disk ---
func save():
	var data := {
		"steps": StepTracker.get_step_count(),
	}
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_string(JSON.stringify(data))

# --- Load from Disk ---
func load():
	if not FileAccess.file_exists(save_path):
		return
	var file = FileAccess.open(save_path, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	if typeof(data) == TYPE_DICTIONARY:
		StepTracker.set_step_count(data.get("steps", 0))
