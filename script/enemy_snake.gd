extends CharacterBody2D

@onready var animated_sprite2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var enemy_stats: Stats = $Stats
@onready var player: Player = get_tree().get_first_node_in_group("player")

@export var item_drop: PackedScene
@export var speed: float = 70.0
@export var acceleration: float = 600.0
@export var friction: float = 800.0

# --- Separation / bump settings ---
@export var stop_distance: float = 12.0               # How close to the player before stopping
@export var separation_radius: float = 32.0           # Radius where enemies start repelling each other
@export var separation_weight: float = 1.5            # How strong the separation is relative to chase
@export var max_neighbors: int = 4                   # Limit neighbors checked (0 = no limit)

var is_dying: bool = false
#var _cached_separation: Vector2 = Vector2.ZERO

func _ready() -> void:
	animated_sprite2d.play("Swimming")
	enemy_stats.health_depleted.connect(_on_health_depleted)
	add_to_group("enemy")

func _on_health_depleted() -> void:
	if is_dying:
		return
	
	is_dying = true
	call_deferred("drop_item")
	queue_free()

func drop_item() -> void:
	print("Item dropped")
	if item_drop:
		var experience_gem = item_drop.instantiate() as ExperienceGem
		experience_gem.xp_amount = 10
		experience_gem.global_position = global_position
		get_parent().add_child(experience_gem)

func _physics_process(delta: float) -> void:
	if is_dying:
		return
	
	if player == null:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		
	if player:
		var to_player: Vector2 = player.global_position - global_position
		var dist_to_player: float = to_player.length()
		
		if dist_to_player > stop_distance:
			var dir_to_player: Vector2 = to_player / dist_to_player
			
			#if Engine.get_physics_frames() % 2 == 0:
				#_cached_separation = _compute_separation()
			
			#var separation: Vector2 = _cached_separation
			
			var separation = _compute_separation()
			
			var combined_dir: Vector2 = dir_to_player + separation * separation_weight
			
			if combined_dir.length() > 0.001:
				combined_dir = combined_dir.normalized()
			else:
				combined_dir = dir_to_player
			
			animated_sprite2d.flip_h = combined_dir.x >= 0.0
			
			var desired_velocity: Vector2 = combined_dir * speed
			velocity = velocity.move_toward(desired_velocity, acceleration * delta)
		else:
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	move_and_slide()

func _compute_separation() -> Vector2:
	var enemies := get_tree().get_nodes_in_group("enemy")
	var steering := Vector2.ZERO
	var neighbour_count := 0
	
	for enemy in enemies:
		if enemy == self:
			continue
		if not (enemy is Node2D):
			continue
		
		var other_pos: Vector2 = enemy.global_position
		var to_self: Vector2 = global_position - other_pos
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
