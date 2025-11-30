extends StatusEffect
class_name IncreaseAttackEffect

@export var attack_delta: float = 15.0

func on_apply(stats: Stats, _stacks: int) -> void:
	stats.bonus_attack += attack_delta

func on_expire(stats: Stats, stacks: int) -> void:
	stats.bonus_attack -= attack_delta * stacks
