extends StatusEffect
class_name MultiplyAttackEffect

@export var multiply_delta: float = 0.6

func on_apply(stats: Stats, _stacks: int) -> void:
	stats.damage_taken_multiplier += multiply_delta

func on_expire(stats: Stats, stacks: int) -> void:
	stats.damage_taken_multiplier -= multiply_delta * stacks
