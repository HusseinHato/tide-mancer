extends StatusEffect
class_name SlowEffect

@export var reduced_move_speed: float = 20

func on_apply(stats: Stats, _stacks: int) -> void:
	stats.bonus_move_speed -= reduced_move_speed
	stats.move_speed_modified.emit()

func on_expire(stats: Stats, stacks: int) -> void:
	stats.bonus_move_speed += reduced_move_speed * stacks
	stats.move_speed_modified.emit()
