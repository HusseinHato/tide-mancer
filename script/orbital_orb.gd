extends Area2D
class_name OrbitalOrb

var damage: float = 1.0
var center_object: Node2D
var start_angle: float = 0.0
var current_angle: float = 0.0
var orbit_radius: float = 100.0
var rotation_speed: float = 3.0
var duration: float = 5.0
var evolved: bool = false

@onready var lifetime_timer: Timer = $LifetimeTimer

func _ready() -> void:
	current_angle = start_angle
	area_entered.connect(_on_area_entered)
	
	if !evolved:
		lifetime_timer.start(duration)
		await lifetime_timer.timeout
		queue_free()

func _physics_process(delta: float) -> void:
	if not is_instance_valid(center_object):
		queue_free()
		return
		
	current_angle += rotation_speed * delta
	# Keep angle within reasonable bounds
	current_angle = fmod(current_angle, TAU)
	
	var offset = Vector2(cos(current_angle), sin(current_angle)) * orbit_radius
	global_position = center_object.global_position + offset

func _on_area_entered(area: Area2D) -> void:
	if area.get_parent().has_node("Stats"):
		var target_stats = area.get_parent().get_node("Stats")
		target_stats.take_damage(damage, "normal")
		# Optional: Don't destroy orb, just knockback or cooldown hit?
		# For now, let's keep it simple: it hits everything it touches.
		# To prevent 60 hits/sec, we might need an internal cooldown per enemy, 
		# but for a basic version, this is fine.
