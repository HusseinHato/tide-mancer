extends UpgradeData
class_name Upgrade_Move_Speed

@export var bonus_move_speed_per_level: float = 50.0

func apply_upgrade(stats: Stats, player: Player, new_level: int) -> void:
	stats.bonus_move_speed += bonus_move_speed_per_level
	player.recalculate_stats()
