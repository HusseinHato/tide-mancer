extends UpgradeData
class_name Upgrade_Health

@export var hp_per_level: float = 25.0

func apply_upgrade(stats: Stats, player: Player, new_level: int) -> void:
	stats.bonus_max_health += hp_per_level
	stats.heal(hp_per_level)
