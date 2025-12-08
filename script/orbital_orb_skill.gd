extends Node2D
class_name OrbitalOrbSkill

@export var orb_scene: PackedScene
@export var stats: Stats

@export var damage_per_level: PackedFloat64Array = [1.0, 2.0, 3.0, 6.0]
@export var duration: PackedFloat64Array = [5.0, 5.2, 5.4, 5.6]
@export var cooldown: PackedFloat64Array = [8.0, 7.6, 7.2, 5.61]

@export var max_level: int = 4
var level: int = 0
@onready var timer: Timer = $Timer

var pre_evolved_orb: Array[OrbitalOrb] = []
var evolved_orb: Array[OrbitalOrb] = []

var bonus_rotation_speed: float = 0.0
const BONUS_EVOLVED_ROTATION_SPEED: float = 1.5

func _ready() -> void:
	timer.timeout.connect(_activate_shield)

func set_level(new_level: int) -> void:
	new_level = clamp(new_level, 0, max_level)
	if new_level == level: return
	level = new_level
	
	timer.wait_time = cooldown[min(level - 1, cooldown.size() - 1)] - (stats.get_fire_rate() / 10)
	
	if level >= max_level:
		timer.stop()
		_evolve()
	
	if level > 0 and timer.is_stopped():
		timer.start()
		_activate_shield() # Immediate cast on learn

func _activate_shield() -> void:
	if level <= 0: return
	
	var base_count = 2 + (level) # 3, 4, 5, 6 orbs
	var count = base_count + stats.get_projectile_count()
	var dmg = damage_per_level[min(level - 1, damage_per_level.size() - 1)]
	
	var angle_step = TAU / count
	
	for i in range(count):
		var orb = orb_scene.instantiate()
		orb.damage = dmg + stats.get_attack()
		orb.center_object = get_parent() # Assuming Skill is child of Player
		orb.start_angle = i * angle_step
		orb.duration = duration[min(level - 1, duration.size() - 1)] - (stats.get_fire_rate() / 10)
		orb.orbit_radius = 100.0 + (stats.bonus_projectile_size * 20.0)
		orb.rotation_speed = 1.5 * (stats.get_projectile_speed() / 300.0) + bonus_rotation_speed
		orb.scale = Vector2.ONE * stats.get_projectile_size()
		
		pre_evolved_orb.append(orb)
		
		get_tree().current_scene.add_child.call_deferred(orb)

func _evolve() -> void:
	bonus_rotation_speed += BONUS_EVOLVED_ROTATION_SPEED
