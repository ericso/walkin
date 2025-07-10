extends Node

var steps: float = 0.0

signal steps_updated(new_total: int)


func add_steps(count: float = 1.0):
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

# calculate_step_delta retuns the number of steps taken for the given time delta
# in seconds (to match the `void _process(delta: float) virtual` call in the main loop)
func calculate_step_delta(delta: float) -> float:
	var step_count: float = 0.0
	var unlocked := UpgradeManager.get_upgrade_unlock_status()
	for id in unlocked:
		if unlocked[id]:
			step_count += UpgradeManager.get_step_rate(id) * delta
	print("DEBUG::calculate_step_delta " + str(delta))
	print("DEBUG::calculate_step_delta " + str(step_count))
	return step_count
