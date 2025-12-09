extends Resource
class_name RawUpgradeData

@export var id: StringName
@export var name: String
@export_multiline var description: String
@export var icon: Texture2D

@export var target_stat: String
@export var is_percentage: bool = false

@export_group("Value Ranges")
@export var common_range: Vector2 = Vector2(10, 15)
@export var greater_range: Vector2 = Vector2(15, 25)
@export var super_range: Vector2 = Vector2(25, 40)

func generate_upgrade(rarity: Enums.Rarity) -> Dictionary:
	var range_vec: Vector2
	match rarity:
		Enums.Rarity.COMMON:
			range_vec = common_range
		Enums.Rarity.GREATER:
			range_vec = greater_range
		Enums.Rarity.SUPER:
			range_vec = super_range
	
	var value: float
	if is_percentage:
		value = randf_range(range_vec.x, range_vec.y) / 100.0
	else:
		value = float(randi_range(int(range_vec.x), int(range_vec.y)))
	
	return {
		"stat": target_stat,
		"value": value,
		"rarity": rarity
		}

func apply(stats: Stats, value: float) -> void:
	var current = stats.get(target_stat)
	stats.set(target_stat, current + value)
