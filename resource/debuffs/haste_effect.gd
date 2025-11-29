extends StatusEffect
class_name HasteEffect

@export var move_speed_delta: float = 300.0

func on_apply(stats: Stats, _stacks: int) -> void:
	stats.bonus_move_speed += move_speed_delta
	print("Move Speed modified, now %s" % stats.get_move_speed())
	stats.move_speed_modified.emit()

func on_expire(stats: Stats, stacks: int) -> void:
	stats.bonus_move_speed -= move_speed_delta * stacks
	print("Move Speed restored, now: %s" % stats.get_move_speed())
	stats.move_speed_modified.emit()
