extends Node2D
class_name BoungGlaiveSkill

@export var glaive_scene: PackedScene
@export var stats: Stats

@export var damage_per_level: PackedFloat64Array = [3.0, 4.0, 5.0, 6.0]
@export var cooldown_per_level: PackedFloat64Array = [4.0, 3.5, 3.0, 2.5]

@export var max_level: int = 4

var level: int = 0
@onready var timer: Timer = $Timer

func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)
	#set_level(4)

func set_level(new_level: int) -> void:
	level = clamp(new_level, 0, max_level)
	if level > 0:
		var idx = min(level - 1, cooldown_per_level.size() - 1)
		timer.wait_time = cooldown_per_level[idx]
		if timer.is_stopped(): timer.start()

func _on_timer_timeout() -> void:
	if level <= 0: return
	
	var count = 1 + stats.get_projectile_count() # Multi-cast
	var dmg = damage_per_level[min(level - 1, damage_per_level.size() - 1)]
	
	for i in range(count):
		_spawn_glaive(dmg + stats.get_attack())
		await get_tree().create_timer(0.2).timeout

func _spawn_glaive(dmg: float) -> void:
	if not glaive_scene: return
	var glaive = glaive_scene.instantiate() as BouncingGlaive
	glaive.damage = dmg
	glaive.bounces = 2 + stats.get_piercing_count() + (level - 1)
	glaive.speed = stats.get_projectile_speed()
	glaive.proj_scale = stats.get_projectile_size()
	
	# Aim at nearest enemy or mouse
	var target_pos = get_global_mouse_position()
	# Optional: Auto-aim nearest
	var enemies = get_tree().get_nodes_in_group("enemy")
	var closest = null
	var min_dist = INF
	for e in enemies:
		var d = global_position.distance_to(e.global_position)
		if d < min_dist:
			min_dist = d
			closest = e
	
	if closest:
		target_pos = closest.global_position
	
	glaive.global_position = global_position
	glaive.direction = (target_pos - global_position).normalized()
	
	get_tree().current_scene.add_child(glaive)
