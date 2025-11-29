extends Node
class_name Stats
signal health_depleted
signal health_changed(current_health: float, max_health: float)
signal move_speed_modified()

const FLOATING_TEXT_SCENE: PackedScene = preload("uid://db23xusumj27x")
const CRITICAL_FLOATING_TEXT_SCENE: PackedScene = preload("uid://ccy03g0aptbgt")
const PLAYER_FLOATING_TEXT_SCENE: PackedScene = preload("uid://dinnlfbshpkyp")
const HEAL_FLOATING_TEXT_SCENE: PackedScene = preload("uid://b8yxa0aqbcfah")

@export var base_max_health: float = 100.0
@export var base_defense: float = 10.0
@export var base_attack: float = 10.0
@export var base_evasion: float = 0.0
@export var base_move_speed: float = 300.0
@export var base_crit_chance: float = 0.0
@export var base_crit_dmg: float = 1.0
@export var base_projectile_speed: float = 300.0
@export var base_fire_rate: float = 1

#Runtime HP
var health: float = 0.0

# Flat bonuses (from items, buffs, etc.)
var bonus_max_health: float = 0.0
var bonus_defense: float = 0.0
var bonus_attack: float = 0.0
var bonus_evasion: float = 0.0
var bonus_move_speed: float = 0.0
var bonus_crit_chance: float = 0.0
var bonus_crit_dmg: float = 0.0
var bonus_projectile_speed: float = 0.0
var bonus_fire_rate: float = 0.0
var bonus_projectile_count: int = 0
var bonus_piercing_count: int = 0
var bonus_projectile_size: float = 1.0

# Multipliers (usually from temporary effects)
var attack_multiplier: float = 1.0
var move_speed_multiplier: float = 1.0
var projectile_speed_multiplier: float = 1.0
var damage_taken_multiplier: float = 1.0  # for "take more/less damage" debuffs
var fire_rate_multiplier: float = 1.0

# Getters
func get_max_health() -> float:
	return max(1.0, base_max_health + bonus_max_health)

func get_defense() -> float:
	return max(0.0, base_defense + bonus_defense)

func get_attack() -> float:
	return max(0.0, (base_attack + bonus_attack) * attack_multiplier)

func get_evasion() -> float:
	return clamp(base_evasion + bonus_evasion, 0.0, 0.95)

func get_move_speed() -> float:
	return max(0.0, (base_move_speed + bonus_move_speed) * move_speed_multiplier)

func get_crit_chance() -> float:
	return clamp(base_crit_chance + bonus_crit_chance, 0.0, 1.0)

func get_crit_dmg() -> float:
	return max(1.0, base_crit_dmg + bonus_crit_dmg)

func get_projectile_speed() -> float:
	return max(0.0, (base_projectile_speed + bonus_projectile_speed) * projectile_speed_multiplier)

func get_fire_rate() -> float:
	return max(0.0, (base_fire_rate + bonus_fire_rate) * fire_rate_multiplier)

func get_projectile_count() -> int:
	return max(0, bonus_projectile_count)

func get_piercing_count() -> int:
	return max(0, bonus_piercing_count)

func get_projectile_size() -> float:
	return max(1.0, bonus_projectile_size)

func _ready() -> void:
	health = get_max_health()

# Core Combat
var _rng := RandomNumberGenerator.new()

func take_damage(raw_damage: float, type: String) -> void:
	# Evasion Check
	if _rng.randf() < get_evasion() and type == "normal":
		print("Attack Evaded")
		return
	
	var dmg = raw_damage
	
	# Defense Mitigation
	# defense = 0 => 100% Damage, Defense = 100 => 50%, etc.
	if type == "normal":
		var def_factor := 100.0 / (100.0 + get_defense())
		dmg = raw_damage * def_factor
	
		# Damage Taken Multipliers from debuffs/buffs
		dmg *= damage_taken_multiplier
		dmg = max(dmg, 1.0) #always at least 1
	
	health = max(health - dmg, 0.0)
	print("Took %.1f dmg (hp: %.1f/%.1f)" % [dmg, health, get_max_health()])
	health_changed.emit(health, get_max_health())
	
	var text_instance: Label
	var formatted_text: String = "%d" % dmg
	if owner is Player:
		text_instance = PLAYER_FLOATING_TEXT_SCENE.instantiate()
	elif type == "critical":
		text_instance = CRITICAL_FLOATING_TEXT_SCENE.instantiate()
		formatted_text = "%d!!" % dmg
	else:
		text_instance = FLOATING_TEXT_SCENE.instantiate()
	text_instance.text = formatted_text
	
	text_instance.global_position = get_parent().global_position
	get_tree().current_scene.add_child.call_deferred(text_instance)
	
	if health <= 0.0 and (health + dmg) > 0:
		health_depleted.emit()

func heal(amount: float) -> void:
	health = min(health + amount, get_max_health())
	#print("Heal %.1f (hp: %.1f/%.1f)" % [amount, health, get_max_health()])
	health_changed.emit(health, get_max_health())
	var heal_text_instance = HEAL_FLOATING_TEXT_SCENE.instantiate()
	heal_text_instance.text = "%d" % amount
	heal_text_instance.global_position = get_parent().global_position
	get_tree().current_scene.add_child.call_deferred(heal_text_instance)
