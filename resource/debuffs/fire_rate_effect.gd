extends StatusEffect
class_name FireRateEffect

@export var fire_rate_delta: float = 1

func on_apply(stats: Stats, _stacks: int) -> void:
	stats.bonus_fire_rate += fire_rate_delta
	print("Fire rate from player modified: now %.f" % stats.get_fire_rate())

func on_expire(stats: Stats, stacks: int) -> void:
	stats.bonus_fire_rate -= fire_rate_delta * stacks
	print("Fire rate from player restored: now %.f" % stats.get_fire_rate())
