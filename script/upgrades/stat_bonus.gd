extends Resource
class_name StatBonus

@export var stat_name: String
@export var base_value: float = 0.1
@export var value_per_level: float = 0.05

func get_value_at_level(level: int) -> float:
	return base_value + (value_per_level * (level - 1))\
