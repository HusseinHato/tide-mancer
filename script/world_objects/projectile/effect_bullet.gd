extends EnemyBullet
class_name EffectBullet

@export var status_effect: StatusEffect

func _on_area_entered(area: Area2D) -> void:
	var target_stats: Stats = area.get_parent().get_node_or_null("Stats")
	var target_status_controller: StatusController = area.get_parent().get_node_or_null("StatusController")
	if target_stats:
		randomize()
		target_stats.take_damage(damage, "normal")
		if randf() < target_stats.get_evasion():
			return
		if target_status_controller:
			target_status_controller.apply_effect(status_effect)
	
	queue_free()
