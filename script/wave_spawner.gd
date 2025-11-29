extends Node2D
class_name WaveSpawner

@onready var _timer: Timer = $Timer

@export var player: Player
@export var area_scene: PackedScene
@export var spawn_interval: float = 4.0
@export var max_areas: int = 10

@export var min_radius: float = 200.0
@export var max_radius: float = 400.0
@export var min_distance_between_areas: float = 600.0

const MAX_ATTEMPTS := 25

var _active_areas: Array[Area2D] = []

func _ready() -> void:
	randomize()
	
	_timer.wait_time = spawn_interval
	_timer.timeout.connect(_on_spawn_timeout)
	_timer.start()

func _on_spawn_timeout() -> void:
	_active_areas = _active_areas.filter(func(a): return is_instance_valid(a))
	
	if _active_areas.size() >= max_areas:
		return
	
	var pos = _find_free_position_near_player()
	if pos == null:
		return
	
	var area := area_scene.instantiate() as Area2D
	area.global_position = pos
	add_child(area)
	
	_active_areas.append(area)

func _find_free_position_near_player() -> Variant:
	if !player:
		return

	var attempts := 0
	
	while attempts < MAX_ATTEMPTS:
		attempts += 1
		
		var angle := randf() * TAU
		var radius := randf_range(min_radius, max_radius)
		var offset := Vector2.RIGHT.rotated(angle) * radius
		var candidate := player.global_position + offset
		
		var ok := true
		for a in _active_areas:
			if not is_instance_valid(a):
				continue
			if candidate.distance_to(a.global_position) < min_distance_between_areas:
				ok = false
				break
		
		if ok:
			return candidate
	
	return null
