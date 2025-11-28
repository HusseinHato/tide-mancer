extends Area2D
class_name EnemyHitbox

var damage: float = 10.0
var attack_cooldown: float = 1.0

var current_target: Area2D
var time_since_last_attack: float = 0.0
var enemy: Enemy

func _ready() -> void:
	enemy = owner
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	
	damage = enemy.stats.get_attack()
	attack_cooldown /= enemy.stats.get_fire_rate()

func _physics_process(delta: float) -> void:
	time_since_last_attack += delta
	
	if time_since_last_attack >= attack_cooldown and current_target:
		deal_damage_to_target()
		time_since_last_attack = 0.0

func deal_damage_to_target() -> void:
	if is_instance_valid(current_target) and current_target:
		var target_stats: Stats = current_target.get_parent().get_node_or_null("Stats")
		if target_stats:
			target_stats.take_damage(damage, "normal")

func _on_area_entered(area: Area2D) -> void:
	if area != current_target:
		current_target = area

func _on_area_exited(area: Area2D) -> void:
	if area == current_target:
		current_target = null
