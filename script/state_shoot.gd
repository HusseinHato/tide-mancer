extends EnemyState
class_name StateShoot

var soft_collision: Area2D

@export var projectile_scene: PackedScene
@export var resume_chase_distance: float = 250.0

# --- Separation tuning ---
@export var separation_radius: float = 32.0      # how close is "clumped"
@export var separation_weight: float = 2.0       # how strong the push
@export var max_neighbors: int = 4               # limit neighbors checked (0 = no limit)

# --- Firing ---
@export var fire_spread: float = 0.15            # random offset per shot (prevents machine-gun sync)

var current_separation: Vector2 = Vector2.ZERO
var cooldown_timer: float = 0.0
var dir_to_player: Vector2 = Vector2.ZERO

func enter() -> void:
	enemy.animated_sprite2d.play("attacking")
	cooldown_timer = (1.0 / enemy.stats.get_fire_rate()) + randf_range(-fire_spread, fire_spread)

func physics_update(delta: float) -> void:
	if !enemy.player:
		return

	# Aim at player (visuals only)
	dir_to_player = enemy.global_position.direction_to(enemy.player.global_position)
	
	#enemy.animated_sprite2d.flip_h = dir_to_player.x >= 0.0
	if abs(dir_to_player.x) > 0.1:
		enemy.animated_sprite2d.flip_h = dir_to_player.x > 0.0
			
	# Separation only if clumped
	var separation_dir: Vector2 = _compute_separation()

	if separation_dir.length_squared() > 0.0001:
		# We are too close to someone → small push away
		var push_speed := enemy.speed      # you can lower this if they slide too far
		var target_velocity := separation_dir.normalized() * push_speed
		enemy.velocity = enemy.velocity.move_toward(target_velocity, enemy.acceleration * delta)
	else:
		# Not clumped → stand still (velocity goes to 0)
		enemy.velocity = enemy.velocity.move_toward(Vector2.ZERO, enemy.acceleration * delta)

func update(delta: float) -> void:
	cooldown_timer -= delta
	
	if !enemy.player:
		return
	
	dir_to_player = enemy.global_position.direction_to(enemy.player.global_position)
	
	if cooldown_timer <= 0.0:
		_shoot()
		cooldown_timer = (1.0 / enemy.stats.get_fire_rate()) + randf_range(-fire_spread, fire_spread)
	
	var distance = enemy.global_position.distance_to(enemy.player.global_position)
	if distance > resume_chase_distance:
		state_machine.change_state("StateChase")

func _shoot() -> void:
	if !projectile_scene:
		return
	
	var proj = projectile_scene.instantiate() as EnemyBullet
	
	if proj.has_method("initialize"):
		proj.initialize(dir_to_player, enemy.stats.get_projectile_speed(), enemy.stats.get_attack())
	else:
		if "direction" in proj:
			proj.direction = dir_to_player
		if "speed" in proj:
			proj.speed = enemy.stats.get_projectile_speed()
		if "damage" in proj:
			proj.damage = enemy.stats.get_attack()
	
	get_tree().root.add_child(proj)
	proj.global_position = enemy.global_position
	proj.rotation = enemy.rotation

#func _compute_separation() -> Vector2:
	#if separation_radius <= 0.0:
		#return Vector2.ZERO
#
	#var enemies := get_tree().get_nodes_in_group("enemy")
	#var steering := Vector2.ZERO
	#var neighbour_count := 0
	#
	#var radius_sq := separation_radius * separation_radius
	#
	#for enemy_instance in enemies:
		#if enemy_instance == enemy:
			#continue
			#
		#var to_self: Vector2 = enemy.global_position - enemy_instance.global_position
		#var dist_sq: float = to_self.length_squared()
		#
		## Perfect overlap → random nudge
		#if dist_sq < 0.01:
			#steering += Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
			#neighbour_count += 1
		#elif dist_sq < radius_sq:
			## Only when really close (clumped) we push away
			#var dist := sqrt(dist_sq)
			#var strength := 1.0 - (dist / separation_radius) # closer → stronger
			#steering += (to_self / dist) * strength
			#neighbour_count += 1
		#
		#if max_neighbors > 0 and neighbour_count >= max_neighbors:
			#break
	#
	#if neighbour_count == 0:
		#return Vector2.ZERO
	#
	#return (steering / neighbour_count) * separation_weight

func _compute_separation() -> Vector2:
	if not soft_collision:
		soft_collision = enemy.get_node("SoftCollision")
	
	var areas = soft_collision.get_overlapping_areas()
	
	if areas.is_empty():
		return Vector2.ZERO
	
	#var enemies = get_tree().get_nodes_in_group("enemy")
	var steering := Vector2.ZERO
	var neighbour_count := 0
	
	for area in areas:
		#if enemy_instance == enemy:
			#continue
		#if not (enemy_instance is Node2D):
			#continue
		var other_enemy = area.get_parent() as Enemy
		if other_enemy == enemy:
			continue
		
		#var other_pos: Vector2 = enemy_instance.global_position
		var to_self: Vector2 = enemy.global_position - other_enemy.global_position
		#var dist: float = to_self.length()
		var dist: float = to_self.length_squared()
		
		#if dist <= 0.001:
			#continue
		#if dist > separation_radius:
			#continue
		if dist <= 0.001:
			steering += Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
			neighbour_count += 1
			continue
		
		#var strength := 1.0 - (dist / separation_radius)
		#steering += to_self.normalized() * strength
		#neighbour_count += 1
		steering += to_self.normalized()
		neighbour_count += 1
		
		if max_neighbors > 0 and neighbour_count >= max_neighbors:
			break
		
	if neighbour_count == 0:
		return Vector2.ZERO
	
	steering /= neighbour_count
	return steering
