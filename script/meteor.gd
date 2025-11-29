extends Area2D
class_name Meteor

@onready var timer: Timer = $Timer
@onready var animation_player: AnimatedSprite2D = $AnimatedSprite2D
@onready var colission_shape: CollisionShape2D = $CollisionShape2D

var damage: float = 10.0
var fall_speed: float = 150.0
var size: float = 1.2
var piercing_count: int = 0

func _ready() -> void:
	animation_player.scale = Vector2(size, size)
	colission_shape.scale = Vector2(size, size)
	animation_player.play("falling")
	
	area_entered.connect(_on_area_entered)
	
	timer.timeout.connect(_on_timer_timeout)
	
	scale.x = size
	scale.y = size

func _physics_process(delta: float) -> void:
	global_position.y += fall_speed * delta

func _on_area_entered(area: Area2D) -> void:
	if area.get_parent().has_node("Stats"):
		var target_stats: Stats = area.get_parent().get_node("Stats")
		target_stats.take_damage(damage, "normal")
	if piercing_count > 0:
		piercing_count -= 1
	else:
		queue_free()

func _on_timer_timeout() -> void:
	queue_free()
