extends Node2D
class_name VoidFissureSkill

@export var fissure_scene: PackedScene
@export var stats: Stats

@export var damage_per_level: PackedFloat64Array = [1.0, 2.0, 3.0, 4.0] # Per tick
@export var cooldown: float = 1.0
@export var max_level: int = 4
var level: int = 0
@onready var timer: Timer = $Timer

func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)
	timer.wait_time = cooldown
	set_level(1)

func set_level(new_level: int) -> void:
	level = clamp(new_level, 0, max_level)
	if level > 0 and timer.is_stopped():
		timer.start()

func _on_timer_timeout() -> void:
	if level <= 0: return
	
	var count = 1 + stats.get_projectile_count()
	var dmg = damage_per_level[min(level - 1, damage_per_level.size() - 1)]
	
	for i in range(count):
		var fissure = fissure_scene.instantiate()
		fissure.damage = dmg + (stats.get_attack() * 0.5) # 50% attack scaling per tick
		fissure.scale = Vector2.ONE * stats.get_projectile_size()
		
		# Spawn under random enemies
		var enemies = get_tree().get_nodes_in_group("enemy")
		if enemies.size() > 0:
			var target = enemies.pick_random()
			fissure.global_position = target.global_position
		else:
			# Or random position near player
			var offset = Vector2(randf_range(-200, 200), randf_range(-200, 200))
			fissure.global_position = global_position + offset
			
		get_tree().current_scene.get_node("BelowEntities").add_child(fissure)
