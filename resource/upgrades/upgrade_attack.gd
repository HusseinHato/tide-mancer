extends UpgradeData
class_name Upgrade_Attack

@export var attack_per_level: float = 10.0

func apply_upgrade(stats: Stats, player: Player, new_level: int) -> void:
	stats.bonus_attack += attack_per_level
