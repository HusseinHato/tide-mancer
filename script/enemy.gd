extends CharacterBody2D
class_name Enemy

signal enemy_died

@onready var animated_sprite2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var death_component = $DeathComponent

@export var stats: Stats
@export var speed: float = 70.0
@export var acceleration: float = 370.0
@export var friction: float = 670.0
@export var hp_per_minute: float = 50
@export var defense_per_minute: float = 4
@export var attack_per_minute: = 4
@export var move_speed_per_minute: float = 4
@export var is_buffer: bool = false

var player: Player
var is_dying: bool = false

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	stats.move_speed_modified.connect(_recalculate_stats)
	stats.health_depleted.connect(_die)
	
	_recalculate_stats()

func init_with_time(elapsed: float) -> void:
	var minutes: int = floor(elapsed / 60)
	stats.bonus_max_health += hp_per_minute * minutes
	stats.health = stats.get_max_health()
	stats.bonus_attack = attack_per_minute * minutes
	stats.bonus_defense = defense_per_minute * minutes
	stats.bonus_move_speed = move_speed_per_minute * minutes

func _recalculate_stats() -> void:
	speed = stats.get_move_speed()
	acceleration = speed + 300
	friction = acceleration + 300

func _physics_process(_delta: float) -> void:
	if is_dying:
		return

	move_and_slide()

func _die() -> void:
	if is_dying:
		return
	
	is_dying = true
	enemy_died.emit()
	
	death_component.activate_death()
