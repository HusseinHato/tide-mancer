extends Area2D
class_name SpectralDagger

var damage: float = 1.0
var speed: float = 300.0
var speed_mult: float = 1.0
var crit_chance: float = 0.0
var crit_dmg: float = 1.0
var piercing_count: int = 0
var proj_scale: float = 1.0

enum State { HOVER, SEEK }
var current_state = State.HOVER
var target: Node2D = null
var velocity: Vector2 = Vector2.ZERO

@onready var hover_timer: Timer = $HoverTimer
@onready var lifetime_timer: Timer = $LifeTimeTimer

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	
	scale.x = proj_scale
	scale.y = proj_scale
	
	# Hover for 0.5s then seek
	await hover_timer.timeout
	current_state = State.SEEK
	_find_target()
	
	# Auto destroy after 5s
	await lifetime_timer.timeout
	queue_free()
	

func _find_target():
	var enemies = get_tree().get_nodes_in_group("enemy")
	var closest_dist = INF
	for enemy in enemies:
		var dist = global_position.distance_to(enemy.global_position)
		if dist < closest_dist:
			closest_dist = dist
			target = enemy

func _physics_process(delta: float) -> void:
	if current_state == State.HOVER:
		# Slight bobbing
		position.y += sin(Time.get_ticks_msec() * 0.01) * 0.5
		
	elif current_state == State.SEEK:
		var move_speed = speed * speed_mult
		if is_instance_valid(target):
			var direction = (target.global_position - global_position).normalized()
			# Smooth turn
			var current_dir = Vector2.RIGHT.rotated(rotation)
			var new_dir = current_dir.lerp(direction, 10 * delta).normalized()
			rotation = new_dir.angle()
			position += new_dir * move_speed * delta
		else:
			position += Vector2.RIGHT.rotated(rotation) * move_speed * delta
			_find_target()

func _on_area_entered(area: Area2D) -> void:
	print("Entered")
	if area.get_parent().has_node("Stats"):
		var target_stats = area.get_parent().get_node("Stats")
		var final_dmg = damage
		var type = "normal"
		
		if randf() < crit_chance:
			final_dmg *= crit_dmg
			type = "critical"
			
		target_stats.take_damage(final_dmg, type)
		
		if piercing_count > 0:
			piercing_count -= 1
		else:
			queue_free()
