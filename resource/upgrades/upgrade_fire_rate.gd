extends UpgradeData
class_name Upgrade_Fire_Rate

@export var fire_rate_per_level: float = 0.8

func apply_upgrade(stats: Stats, player: Player, new_level: int) -> void:
	stats.bonus_fire_rate += fire_rate_per_level
