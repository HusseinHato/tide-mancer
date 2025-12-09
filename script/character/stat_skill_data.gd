extends Resource
class_name StatSkillData

enum Trigger {
	ON_LEVEL_UP,
	ON_ATTACK,
	ON_HIT,
	ON_KILL,
	ON_DAMAGE_TAKEN,
	PASSIVE
}

@export var id: StringName
@export var name: String
@export_multiline var description: String
@export var icon: Texture2D
@export var trigger: Trigger = Trigger.PASSIVE

# For passive effects (applied to stats)
@export_group("Passive Effect")
@export var stat_to_modify: String = ""
@export var value_per_level: float = 0.0

# For Triggered Effects
@export_group("Triggered Effect")
@export var effect_chance: float = 0.0
@export var effect_script: Script # Custom script for complex effects

func apply_on_passive_level_up(stats: Stats, player_level: int) -> void:
	if trigger != Trigger.ON_LEVEL_UP or stat_to_modify.is_empty():
		return
	
	if stat_to_modify == "attack_multiplier":
		stats.attack_multiplier += value_per_level
	
	if stat_to_modify == "max_health":
		stats.bonus_max_health += value_per_level
		stats.heal(value_per_level)

func check_triggered_effect(trigger_type: Trigger, context: Dictionary) -> bool:
	if trigger != trigger_type:
		return false
	return randf() < effect_chance
