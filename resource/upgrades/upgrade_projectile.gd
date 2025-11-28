extends UpgradeData
class_name Upgrade_Projectile

@export var projectile_per_level: int = 1

func apply_upgrade(stats: Stats, player: Player, new_level: int) -> void:
	stats.bonus_projectile_count += projectile_per_level
