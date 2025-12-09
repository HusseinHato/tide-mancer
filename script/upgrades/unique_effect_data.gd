extends Resource
class_name UniqueEffectData

enum EffectType {
	ON_HIT_CHANCE,
	SCALING_STAT,
	ON_KILL_CHANCE
}

@export var effect_type: EffectType
@export var effect_name: String

@export_group("Scaling Configuration")
@export var base_value: float = 0.2
@export var value_per_level: float = 0.05
@export var max_value: float = -1.0 # Optional cap (-1 = no limit)

# For scaling effects (e.g., damage scales with missing HP)
@export_group("Conditional Scaling")
@export var scale_condition: String = ""  # e.g., "missing_health_percent"

func get_value_at_level(level: int) -> float:
	var value = base_value + (value_per_level * (level - 1))
	if max_value > 0:
		value = min(value, max_value)
	return value

func get_description_at_level(level: int) -> String:
	var value =  get_value_at_level(level)
	match effect_type:
		EffectType.ON_HIT_CHANCE, EffectType.ON_KILL_CHANCE:
			return "%d%% chance to %s" % [int(value * 100), effect_name]
		EffectType.SCALING_STAT:
			return "+%d%% per %s" % [int(value * 100), scale_condition]
		_:
			return ""

func apply(stats: Stats, player: Player, level: int) -> void:
	var status_controller = player.get_node_or_null("StatusController")
	if status_controller:
		Events.item_effect_registered.emit(self, level)
	
	if effect_type == EffectType.SCALING_STAT:
		stats.register_scaling_effect(self, level)
