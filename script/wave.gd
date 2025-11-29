extends Area2D
class_name Wave

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var life_time: float = 12.0
@export var effects_for_player: Array[StatusEffect]
@export var effects_for_enemies: Array[StatusEffect]

var _elapsed: float = 0.0

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	animated_sprite.play("default")

func _process(delta: float) -> void:
	_elapsed += delta
	if _elapsed >= life_time:
		queue_free()

func _on_body_entered(body: CharacterBody2D):
	randomize()
	
	var effect_for_player: StatusEffect = effects_for_player.pick_random()
	var effect_for_enemy: StatusEffect = effects_for_enemies.pick_random()
	
	
	if body.is_in_group("player"):
		if body.has_node("StatusController"):
			var status_controller: StatusController = body.get_node("StatusController")
			status_controller.apply_effect(effect_for_player)
	
	if body.is_in_group("enemy"):
		if body.has_node("StatusController"):
			var status_controller: StatusController = body.get_node("StatusController")
			status_controller.apply_effect(effect_for_enemy)
