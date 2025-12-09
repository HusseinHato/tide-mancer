extends EnemyHitbox
class_name StatusEffectHitbox

@export var status_effect: StatusEffect

func deal_damage_to_target() -> void:
	if is_instance_valid(current_target) and current_target:
		var target_stats: Stats = current_target.get_parent().get_node_or_null("Stats")
		var target_status_controller: StatusController = current_target.get_parent().get_node_or_null("StatusController")
		if target_stats:
			target_stats.take_damage(damage, "normal")
		if target_status_controller:
			target_status_controller.apply_effect(status_effect)
