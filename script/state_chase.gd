extends EnemyState
class_name StateChase

# --- Separation / bump settings ---
@export var stop_distance: float = 12.0               # How close to the player before stopping
@export var separation_radius: float = 32.0           # Radius where enemies start repelling each other
@export var separation_weight: float = 1.5            # How strong the separation is relative to chase
@export var max_neighbors: int = 4                   # Limit neighbors checked (0 = no limit)
@export var next_state_on_stop: String = ""

var _cached_separation: Vector2

func physics_update(delta: float) -> void:
	
	enemy.animated_sprite2d.play("swimming")
	
	if enemy.player == null:
		enemy.velocity = enemy.velocity.move_toward(Vector2.ZERO, enemy.friction * delta)
		
	if enemy.player:
		var to_player: Vector2 = enemy.player.global_position - enemy.global_position
		var dist_to_player: float = to_player.length()
		
		if dist_to_player > stop_distance:
			var dir_to_player: Vector2 = to_player / dist_to_player
			
			if Engine.get_physics_frames() % 2 == 0:
				_cached_separation = _compute_separation()
			
			var separation: Vector2 = _cached_separation
			
			#var separation = _compute_separation()
			
			var combined_dir: Vector2 = dir_to_player + separation * separation_weight
			
			if combined_dir.length() > 0.001:
				combined_dir = combined_dir.normalized()
			else:
				combined_dir = dir_to_player
			
			enemy.animated_sprite2d.flip_h = combined_dir.x >= 0.0
			
			var desired_velocity: Vector2 = combined_dir * enemy.speed
			enemy.velocity = enemy.velocity.move_toward(desired_velocity, enemy.acceleration * delta)
		else:
			if next_state_on_stop != "":
				enemy.velocity = Vector2.ZERO
				state_machine.change_state(next_state_on_stop)
			else:
				enemy.velocity = enemy.velocity.move_toward(Vector2.ZERO, enemy.friction * delta)

func _compute_separation() -> Vector2:
	var enemies = get_tree().get_nodes_in_group("enemy")
	var steering := Vector2.ZERO
	var neighbour_count := 0
	
	for enemy_instance in enemies:
		if enemy_instance == enemy:
			continue
		if not (enemy_instance is Node2D):
			continue
		
		var other_pos: Vector2 = enemy_instance.global_position
		var to_self: Vector2 = enemy.global_position - other_pos
		var dist: float = to_self.length()
		
		if dist <= 0.001:
			continue
		if dist > separation_radius:
			continue
		
		var strength := 1.0 - (dist / separation_radius)
		steering += to_self.normalized() * strength
		neighbour_count += 1
		
		if max_neighbors > 0 and neighbour_count >= max_neighbors:
			break
		
	if neighbour_count == 0:
		return Vector2.ZERO
	
	steering /= neighbour_count
	return steering
