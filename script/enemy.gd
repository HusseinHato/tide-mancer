extends CharacterBody2D
class_name Enemy

@onready var animated_sprite2d: AnimatedSprite2D = $AnimatedSprite2D

@export var stats: Stats
@export var item_drop: PackedScene
@export var speed: float = 70.0
@export var acceleration: float = 600.0
@export var friction: float = 800.0

var player: Player
var is_dying: bool = false

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	stats.health_depleted.connect(_die)
	
	_recalculate_stats()

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
	call_deferred("_drop_item")
	
	queue_free()

func _drop_item() -> void:
	if item_drop:
		var item = item_drop.instantiate() as ExperienceGem
		item.global_position = global_position
		get_tree().current_scene.get_node("Entities").add_child(item)
