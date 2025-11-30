extends UpgradeData
class_name Upgrade_Evasion

@export var evasion_per_level: float = 0.1

func apply_upgrade(stats: Stats, player: Player, new_level: int) -> void:
	stats.bonus_evasion += evasion_per_level
