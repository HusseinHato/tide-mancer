extends StatusEffect
class_name PoisonEffect

@export var damage_per_tick: float = 5.0

func on_tick(stats: Stats, stacks: int) -> void:
	var dmg := damage_per_tick * stacks
	stats.take_damage(dmg, "debuff")
