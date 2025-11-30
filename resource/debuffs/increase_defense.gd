extends StatusEffect
class_name IncreaseDefenseEffect

@export var defense_delta: float = 15.0

func on_apply(stats: Stats, _stacks: int) -> void:
	stats.bonus_defense += defense_delta

func on_expire(stats: Stats, stacks: int) -> void:
	stats.bonus_defense -= defense_delta * stacks
