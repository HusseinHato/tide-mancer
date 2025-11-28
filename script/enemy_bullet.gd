extends Area2D
class_name EnemyBullet

var direction: Vector2 = Vector2.RIGHT
var speed: float = 400.0
var damage: float = 10.0
var lifetime: float = 5.0

func _ready() -> void:
	area_entered.connect(_on_area_entered) 
	
	var timer := get_tree().create_timer(lifetime)
	timer.timeout.connect(queue_free)

func initialize(dir: Vector2, spd: float, dmg: float) -> void:
	direction = dir.normalized()
	speed = spd
	damage = dmg
	
	rotation = direction.angle()

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _on_area_entered(area: Area2D) -> void:
	var target_stats: Stats = area.get_parent().get_node_or_null("Stats")
	if target_stats:
		target_stats.take_damage(damage, "normal")
	
	queue_free()
