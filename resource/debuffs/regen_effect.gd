extends StatusEffect
class_name RegenEffect

@export var heal_per_tick: float = 10.0

func on_tick(stats: Stats, stacks: int) -> void:
	stats.heal(heal_per_tick * stacks)
