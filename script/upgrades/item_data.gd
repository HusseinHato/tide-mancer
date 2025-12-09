extends Resource
class_name ItemData

@export var id: StringName
@export var name: String
@export_multiline var description: String
@export var rarity: Enums.Rarity = Enums.Rarity.COMMON

@export_group("Stat Bonuses")
@export var stat_bonuses: Array[StatBonus] = []

@export_group("Unique Efect")
@export var has_unique_effect: bool = false
@export var unique_effect: UniqueEffectData

func get_description_at_level(level: int) -> String:
	var desc = description
	for bonus in stat_bonuses:
		var value = bonus.get_value_at_level(level)
		desc = desc.replace("{%s}" % bonus.stat_name, str(value))
	if has_unique_effect:
		desc = desc.replace("{effect}", unique_effect.get_description_at_level(level))
	return desc

func apply(stats: Stats, player: Player, level: int) -> void:
	for bonus in stat_bonuses:
		var value = bonus.get_value_at_level(level)
		var current = stats.get(bonus.stat_name)
		stats.set(bonus.stat_name, current + value)
		
	if has_unique_effect:
		unique_effect.apply(stats, player, level)
