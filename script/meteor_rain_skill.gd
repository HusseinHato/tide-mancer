extends Node2D
class_name MeteorRainSkill

@export var meteor_scene: PackedScene
@export var stats: Stats

@export var damage_per_level: PackedFloat64Array = [10.0, 12.0, 14.0, 16.0]
@export var meteors_per_burst_per_level: PackedInt32Array = [1, 2, 3, 4]
@export var cooldown_per_level: PackedFloat64Array = [3.4, 2.6, 1.8, 1]

@export var max_level: int = 4
@export var evolve_on_level: int = 4

var level: int = 0
@onready var timer: Timer = $Timer

func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)
	_update_timer()
	timer.stop()

func set_level(new_level: int) -> void:
	new_level = clamp(new_level, 0, max_level)
	if new_level == level:
		return
	
	level = new_level
	
	if level <= 0:
		timer.stop()
		return
	
	_update_timer()
	timer.start()
	
	if level >= evolve_on_level:
		_evolve()

func _update_timer() -> void:
	if level <= 0:
		return
	
	var idx := level - 1
	var cd := cooldown_per_level[min(idx, cooldown_per_level.size() - 1)]
	timer.wait_time = cd

func _on_timer_timeout() -> void:
	if level <= 0:
		return
	
	var idx := level - 1
	var count := meteors_per_burst_per_level[min(idx, meteors_per_burst_per_level.size() - 1)] + stats.get_projectile_count()
	var dmg := damage_per_level[min(idx, damage_per_level.size() - 1)]
	
	for i in count:
		_spawn_meteor(dmg)

func _spawn_meteor(dmg: float) -> void:
	var meteor: Meteor = meteor_scene.instantiate()
	meteor.damage = dmg * (stats.get_attack() / 10)
	
	# spawn somewhere around player (above)
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	var offset_x = rng.randf_range(-600.0, 600.0)
	var offset_y = rng.randf_range(-400, -550)
	var start_pos := global_position + Vector2(offset_x, offset_y)
	
	meteor.global_position = start_pos
	get_tree().current_scene.add_child(meteor)
	

func _evolve() -> void:
	print("MeteorRain evolved!")
	# Example: double meteors per burst
	if meteors_per_burst_per_level.size() >= level:
		meteors_per_burst_per_level[level - 1] += 2
