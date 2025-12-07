extends Node2D
class_name SpectralDaggersSkill

@export var dagger_scene: PackedScene
@export var stats: Stats
@export var damage_per_level: PackedFloat64Array = [2.0, 3.0, 4.0, 5.0]
@export var count_per_level: PackedInt32Array = [1, 2, 3, 4]
@export var cooldown_per_level: PackedFloat64Array = [3.6, 3.0, 2.4, 1.8]
@export var max_level: int = 4

var level: int = 0
@onready var timer: Timer = $Timer
@onready var delay_timer: Timer = $DelayTimer

func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)
	_update_timer()
	#set_level(1)

func set_level(new_level: int) -> void:
	new_level = clamp(new_level, 0, max_level)
	if new_level == level: return
	level = new_level
	if level > 0:
		_update_timer()
		if timer.is_stopped(): timer.start()
	else:
		timer.stop()

func _update_timer() -> void:
	if level <= 0: return
	var idx = min(level - 1, cooldown_per_level.size() - 1)
	timer.wait_time = cooldown_per_level[idx]
	
func _on_timer_timeout() -> void:
	if level <= 0: return
	var idx = min(level - 1, count_per_level.size() - 1)
	var count = count_per_level[idx] + stats.get_projectile_count()
	var dmg = damage_per_level[min(level - 1, damage_per_level.size() - 1)]
	
	for i in range(count):
		_spawn_dagger(dmg + stats.get_attack())
		await delay_timer.timeout # Small delay between spawns

func _spawn_dagger(dmg: float) -> void:
	if not dagger_scene: return
	var dagger = dagger_scene.instantiate() as SpectralDagger
	dagger.damage = dmg
	dagger.speed_mult = stats.get_projectile_speed() / 300.0 # Normalize based on base speed
	dagger.crit_chance = stats.get_crit_chance()
	dagger.crit_dmg = stats.get_crit_dmg()
	dagger.piercing_count = stats.get_piercing_count()
	dagger.proj_scale = stats.get_projectile_size()
	
	# Spawn around player
	var offset = Vector2(randf_range(-50, 50), randf_range(-50, 50))
	dagger.global_position = global_position + offset
	
	get_tree().current_scene.add_child(dagger)
