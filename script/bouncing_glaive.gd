extends Area2D
class_name BouncingGlaive

var damage: float = 1.0
var speed: float = 300.0
var bounces: int = 3
var direction: Vector2 = Vector2.RIGHT
var proj_scale: float = 1.0

var hit_enemies = [] # Keep track to avoid bouncing to same enemy immediately

@onready var lifetime_timer: Timer = $LifetimeTimer

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	
	scale.x = proj_scale
	scale.y = proj_scale
	
	animated_sprite.play("default")
	await lifetime_timer.timeout # Failsafe
	queue_free()

func _physics_process(delta: float) -> void:
	position += direction * speed * delta
	#rotation += 10.0 * delta # Spin effect

func _on_area_entered(area: Area2D) -> void:
	if area.get_parent().has_node("Stats"):
		var target_stats = area.get_parent().get_node("Stats")
		target_stats.take_damage(damage, "normal")
		
		hit_enemies.append(area)
		
		if bounces > 0:
			bounces -= 1
			_bounce(area.global_position)
		else:
			queue_free()

func _bounce(from_pos: Vector2) -> void:
	var enemies = get_tree().get_nodes_in_group("enemy")
	var closest = null
	var min_dist = 500.0 # Max bounce range
	
	for enemy in enemies:
		# Check if it's the enemy's hitbox area, not the enemy itself if needed
		# Assuming 'enemy' is the parent node
		if enemy.has_node("EnemyHurtbox"): # Adjust based on your enemy structure
			var hitbox = enemy.get_node("EnemyHurtbox")
			if hitbox in hit_enemies: continue
			
			var d = from_pos.distance_to(enemy.global_position)
			if d < min_dist:
				min_dist = d
				closest = enemy
	
	if closest:
		direction = (closest.global_position - global_position).normalized()
	else:
		# Bounce randomly if no target
		direction = direction.rotated(deg_to_rad(randf_range(120, 240)))
