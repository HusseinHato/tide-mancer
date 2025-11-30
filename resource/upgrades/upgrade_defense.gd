extends UpgradeData
class_name Upgrade_Defense

@export var defense_per_level: float = 10.0

func apply_upgrade(stats: Stats, player: Player, new_level: int) -> void:
	stats.bonus_defense += defense_per_level
