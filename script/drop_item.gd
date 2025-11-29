extends Area2D
class_name DropItem

@export var speed: float = 600.0
@export var steer_force: float = 25.0

var target: Node2D = null
var velocity: Vector2 = Vector2.ZERO

func _ready():
	# Disable magnet logic temporarily
	set_physics_process(false)
	
	# Create a "pop" effect using Tween
	var tween = create_tween()
	# Jump up and to a random side
	var random_offset = Vector2(randf_range(-30, 30), randf_range(-30, -10))
	
	tween.tween_property(self, "global_position", global_position + random_offset, 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	
	tween.tween_callback(func(): set_physics_process(true))

func _physics_process(delta: float) -> void:
	if target:
		# 1. Calculate direction to player
		var direction = global_position.direction_to(target.global_position)
		
		# 2. Add steering behavior (optional, makes it curve nicely like a missile)
		# or simple straight movement: velocity = direction * speed
		var desired_velocity = direction * speed
		velocity = velocity.move_toward(desired_velocity, steer_force)
		
		#3. Move
		global_position += velocity * delta
		
		# 4. Check if collected (simple distance check is cheaper than another collision)
		if global_position.distance_to(target.global_position) < 25.0:
			collect()

func collect() -> void:
	pass

func start_magnet(player_node: Area2D) -> void:
	target = player_node
