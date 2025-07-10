extends Node

var steps: int = 0

signal steps_updated(new_total: int)


func add_steps(count: int = 1):
	steps += count
	emit_signal("steps_updated", steps)
	UpgradeManager.check_unlocks()

func get_step_count() -> int:
	return steps
	
func set_step_count(count: int) -> void:
	steps = count
	emit_signal("steps_updated", steps)

func get_steps_label() -> String:
	return "Steps: %d" % get_step_count()
