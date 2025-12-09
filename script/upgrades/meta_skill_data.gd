extends Resource
class_name MetaSkillData

@export var id: StringName
@export var name: String
@export_multiline var description: String
@export var icon: Texture2D
@export var skill_scene: PackedScene

@export var upgradable_stats: Array[String] = [
	"bonus_projectile_count",
	"bonus_attack",
	"bonus_fire_rate"
]

@export var stat_ranges: Dictionary = {
	"bonus_projectile_count": {
		Enums.Rarity.COMMON: Vector2(1, 1),
		Enums.Rarity.GREATER: Vector2(1, 2),
		Enums.Rarity.SUPER: Vector2(2, 3)
	},
	"bonus_attack": {
		Enums.Rarity.COMMON: Vector2(0.05, 0.10),
		Enums.Rarity.GREATER: Vector2(0.10, 0.20),
		Enums.Rarity.SUPER: Vector2(0.20, 0.30)
	}
}

func generate_upgrade(rarity: Enums.Rarity) -> Dictionary:
	var result = {}
	var stats_to_upgrade = min(2, upgradable_stats.size())
	
	if rarity == Enums.Rarity.SUPER:
		stats_to_upgrade = 2
	elif rarity == Enums.Rarity.GREATER:
		stats_to_upgrade = 1 if randf() > 0.5 else 2
	else:
		stats_to_upgrade = 1
	
	var available = upgradable_stats.duplicate()
	available.shuffle()
	
	for i in range(stats_to_upgrade):
		if i >= available.size():
			break
		var stat = available[i]
		var range_vec = stat_ranges[stat][rarity]
		var value = randf_range(range_vec.x, range_vec.y)
		result[stat] = value
	
	return result
