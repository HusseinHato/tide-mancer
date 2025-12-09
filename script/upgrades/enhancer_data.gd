extends Resource
class_name EnhancerData

@export var id: StringName
@export var name: String
@export_multiline var description: String
@export var icon: Texture2D

@export var target_stat: String
@export var is_percentage: bool = false

@export_group("Value Ranges")
@export var common_range: Vector2 = Vector2(1, 1)
@export var greater_range: Vector2 = Vector2(1, 2)
@export var super_range: Vector2 = Vector2(2, 3)

func generate_value(rarity: Enums.Rarity) -> float:
	var range_vec: Vector2
	match rarity:
		Enums.Rarity.COMMON:
			range_vec = common_range
		Enums.Rarity.GREATER:
			range_vec = greater_range
		Enums.Rarity.SUPER:
			range_vec = super_range
	
	if is_percentage:
		return randf_range(range_vec.x, range_vec.y)
	else:
		return randi_range(int(range_vec.x), int(range_vec.y))

func apply(stats: Stats, rarity: Enums.Rarity) -> float:
	var value = generate_value(rarity)
	stats.set(target_stat, stats.get(target_stat) + value)
	return value
