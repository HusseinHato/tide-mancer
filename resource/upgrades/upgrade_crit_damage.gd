extends UpgradeData
class_name Upgrade_Crit_Damage

@export var crit_dmg_per_level: float = 0.1

func apply_upgrade(stats: Stats, player: Player, new_level: int) -> void:
	stats.bonus_crit_dmg += crit_dmg_per_level
