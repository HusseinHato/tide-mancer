extends Node2D
class_name EnemySpawner

@export var player: Player
@export var enemy_configs: Array[EnemyConfig] = []

@export var spawn_inner_radius: float = 500.0
@export var spawn_outer_radius: float = 800.0

@export var base_spawn_interval: float = 2.5
@export var min_spawn_interval: float = 0.4
@export var spawn_interval_decay_per_sec: float = 0.02

@export var base_enemies_per_wave: int = 8
@export var max_enemies_per_wave: int = 8
@export var enemies_per_minute_growth: float = 1.5

@export var max_enemies_alive: int = 300

var _elapsed: float = 0.0
@onready var _timer: Timer = $Timer

func _ready() -> void:
	_timer.timeout.connect(_on_spawn_tick)
	_timer.start(0.01)

func _process(delta: float) -> void:
	_elapsed += delta

func _on_spawn_tick() -> void:
	# 1) Compute new spawn interval (faster over time)
	var new_interval := base_spawn_interval - spawn_interval_decay_per_sec * _elapsed
	new_interval = max(min_spawn_interval, new_interval)
	
	# 2) Compute how many enemies to spawn in this wave
	var minutes := _elapsed / 60.0
	var base_wave := base_enemies_per_wave + int(minutes * enemies_per_minute_growth)
	var wave_count = clamp(base_wave, base_enemies_per_wave, max_enemies_per_wave)
	
	# 3) Respect max_enemies_alive limit
	var current_alive := get_tree().get_nodes_in_group("enemy").size()
	var allowed := max_enemies_alive - current_alive
	if allowed <= 0:
		wave_count = 0
	else:
		wave_count = min(wave_count, allowed)
	
	if wave_count > 0:
		_spawn_wave(wave_count)
	
	_timer.start(new_interval)

func _spawn_wave(count: int) -> void:
	if !player:
		return
	
	var configs := _get_unlocked_configs()
	if configs.is_empty():
		return
	
	for i in count:
		var cfg := _pick_weighted(configs)
		if cfg == null or cfg.scene == null:
			continue
		
		var enemy := cfg.scene.instantiate()
		if enemy is Node2D:
			enemy.global_position = _random_spawn_position()
		else:
			enemy.position = _random_spawn_position()
		
		var current_scene = get_tree().current_scene.get_node_or_null("Entities")
		if current_scene:
			current_scene.add_child(enemy)
	

func _get_unlocked_configs() -> Array[EnemyConfig]:
	var arr: Array[EnemyConfig] = []
	for cfg in enemy_configs:
		if _elapsed >= cfg.unlock_time:
			arr.append(cfg)
	return arr

func _pick_weighted(configs: Array[EnemyConfig]) -> EnemyConfig:
	var total_weight := 0.0
	for cfg in configs:
		total_weight += cfg.weight
	
	if total_weight <= 0.0:
		return configs[0]
	
	var rng := RandomNumberGenerator.new()
	rng.randomize()
	
	var r := rng.randf() * total_weight
	var acc := 0.0
	for cfg in configs:
		acc += cfg.weight
		if r <= acc:
			return cfg
			
	return configs.back()

func _random_spawn_position() -> Vector2:
	var rng := RandomNumberGenerator.new()
	rng.randomize()
	
	var vpr = get_viewport_rect().size * randf_range(0.57, 0.65)
	var top_left = Vector2(player.global_position.x - vpr.x, player.global_position.y - vpr.y)
	var top_right = Vector2(player.global_position.x + vpr.x, player.global_position.y - vpr.y)
	var bottom_left = Vector2(player.global_position.x - vpr.x, player.global_position.y + vpr.y)
	var bottom_right = Vector2(player.global_position.x + vpr.x, player.global_position.y + vpr.y)
	var pos_side = ["up", "down", "left", "right"].pick_random()
	var spawn_pos1 = Vector2.ZERO
	var spawn_pos2 = Vector2.ZERO
	
	match pos_side:
		"up":
			spawn_pos1 = top_left
			spawn_pos2 = top_right
		"down":
			spawn_pos1 = bottom_left
			spawn_pos2 = bottom_right
		"left":
			spawn_pos1 = top_left
			spawn_pos2 = bottom_left
		"right":
			spawn_pos1 = top_right
			spawn_pos2 = bottom_right
	
	var x_spawn = randf_range(spawn_pos1.x, spawn_pos2.x)
	var y_spawn = randf_range(spawn_pos1.y, spawn_pos2.y)
	
	return Vector2(x_spawn, y_spawn)
