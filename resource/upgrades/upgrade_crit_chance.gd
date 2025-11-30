extends UpgradeData
class_name Upgrade_Crit_Chance

@export var crit_chance_per_level: float = 0.1

func apply_upgrade(stats: Stats, player: Player, new_level: int) -> void:
	stats.bonus_crit_chance += crit_chance_per_level
