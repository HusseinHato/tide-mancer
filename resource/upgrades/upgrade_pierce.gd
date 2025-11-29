extends UpgradeData
class_name Upgrade_Pierce

@export var pierce_per_level: int = 1

func apply_upgrade(stats: Stats, player: Player, new_level: int) -> void:
	stats.bonus_piercing_count += pierce_per_level
