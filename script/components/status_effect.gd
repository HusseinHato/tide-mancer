extends Resource
class_name StatusEffect

@export var id: StringName
@export var is_buff: bool
@export var icon: Texture2D
@export var duration: float
@export var tick_interval: float
@export var max_stacks: int

func on_apply(stats: Stats, stacks: int) -> void:
	pass
	
func on_tick(stats: Stats, stacks: int) -> void:
	pass

func on_expire(stats: Stats, stacks: int) -> void:
	pass
