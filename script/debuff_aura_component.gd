extends BuffAuraComponent
class_name DebuffAreaComponent

func _on_buff_tick() -> void:
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body is Player and body != owner:
			if body.has_node("StatusController"):
				var status_controller = body.get_node("StatusController") as StatusController
				status_controller.apply_effect(status_effect)
