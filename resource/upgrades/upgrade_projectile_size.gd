extends UpgradeData
class_name Upgrade_Projectile_Size

@export var bonus_size_per_level: float = 0.25

func apply_upgrade(stats: Stats, player: Player, new_level: int) -> void:
	stats.bonus_projectile_size += bonus_size_per_level
