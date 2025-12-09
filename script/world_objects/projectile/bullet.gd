extends Area2D
class_name Bullet

@onready var timer: Timer = $Timer

var direction: Vector2 =Vector2.RIGHT
var speed: float = 400.0
var damage: float = 10.0
var lifetime: float = 5.0
var projectile_size: float = 1.0
var piercing_count_before_broke: int = 0

var critical_hit: bool = false

func _ready() -> void:
	area_entered.connect(_on_area_entered) 
	
	timer.timeout.connect(queue_free)
	timer.start(lifetime)

func initialize(dir: Vector2, spd: float, dmg: float, piercing_count: int, proj_size: float) -> void:
	direction = dir.normalized()
	speed = spd
	damage = dmg
	piercing_count_before_broke = piercing_count
	scale.x = projectile_size * proj_size
	scale.y = projectile_size * proj_size
	
	rotation = direction.angle()

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _on_area_entered(area: Area2D) -> void:
	var target_stats: Stats = area.get_parent().get_node_or_null("Stats")
	if target_stats:
		if critical_hit:
			target_stats.take_damage(damage, "critical")
		else:
			target_stats.take_damage(damage, "normal")
	
	if piercing_count_before_broke > 0:
		piercing_count_before_broke -= 1
	else:
		queue_free()
