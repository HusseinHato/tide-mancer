extends Area2D
class_name Wave

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var apply_buff_timer: Timer = $ApplyBuffTimer

@export var life_time: float = 15.0
@export var effects_for_player: Array[StatusEffect]
@export var effects_for_enemies: Array[StatusEffect]
@export var tick_per_apply_buff: float = 3
@export var wave_sound: AudioStream

var _elapsed: float = 0.0
var _bodies: Array[CharacterBody2D] = []

var effect_for_player: StatusEffect
var effect_for_enemy: StatusEffect

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	animated_sprite.play("default")
	SoundManager.play_world_sfx(wave_sound, global_position, -11.0)
	
	randomize()
	
	effect_for_player = effects_for_player.pick_random()
	effect_for_enemy = effects_for_enemies.pick_random()
	
	apply_buff_timer.wait_time = tick_per_apply_buff
	apply_buff_timer.timeout.connect(_on_apply_buff_timer_timeout)

func _process(delta: float) -> void:
	_elapsed += delta
	if _elapsed >= life_time:
		queue_free()

func _on_apply_buff_timer_timeout() -> void:
	apply_buff_and_debuff()

func _on_body_entered(body: CharacterBody2D):
	if body.is_in_group("player"):
		if body.has_node("StatusController"):
			var status_controller: StatusController = body.get_node("StatusController")
			status_controller.apply_effect(effect_for_player)
	
	if body.is_in_group("enemy"):
		if body.has_node("StatusController"):
			var status_controller: StatusController = body.get_node("StatusController")
			status_controller.apply_effect(effect_for_enemy)
	
	_bodies.append(body)

func _on_body_exited(body: CharacterBody2D):
	if is_instance_valid(body):
		_bodies.erase(body)

func apply_buff_and_debuff() -> void:
	if _bodies.is_empty():
		return
	
	for body in _bodies:
		if body.is_in_group("player"):
			if body.has_node("StatusController"):
				var status_controller: StatusController = body.get_node("StatusController")
				status_controller.apply_effect(effect_for_player)
	
		if body.is_in_group("enemy"):
			if body.has_node("StatusController"):
				var status_controller: StatusController = body.get_node("StatusController")
				status_controller.apply_effect(effect_for_enemy)
