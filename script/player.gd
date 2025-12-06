extends CharacterBody2D
class_name Player

signal player_dead

@export var speed: float = 300.0
@export var acceleration: float = 900.0
@export var friction: float = 1200.0


@onready var sprite: Sprite2D = $Sprite2D
@onready var stats: Stats = $Stats

@export var weapon: Weapon
@export var pistol_weapon: WeponData
@export var shotgun_weapon: WeponData

const DEATH_SEQUENCE_SCENE = preload("uid://bvubwdvb1xn5w")

func _ready() -> void:
	stats.health_depleted.connect(died)
	stats.move_speed_modified.connect(recalculate_stats)
	
	Events.hot_dog_picked.connect(_on_hotdog_picked)
	
	recalculate_stats()

func recalculate_stats() -> void:
	speed = stats.get_move_speed()
	acceleration = speed * 2.5
	friction = acceleration * 3.5 

func _process(delta: float) -> void:
	var input_dir = Input.get_vector("left", "right", "up", "down")
	
	if Input.is_action_just_pressed("switch_weapon"):
		switch_weapon()
	
	if input_dir != Vector2.ZERO:
		velocity = velocity.move_toward(input_dir * speed, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	if input_dir.x < 0:
		sprite.flip_h = true
	elif input_dir.x > 0:
		sprite.flip_h = false
	
	move_and_slide()

func died() -> void:
	visible = false
	var death_sequence: DeathSequence = DEATH_SEQUENCE_SCENE.instantiate()
	get_tree().root.add_child(death_sequence)
	death_sequence.start_death_sequence()
	player_dead.emit()

func switch_weapon() -> void:
	if weapon:
		if weapon.weapon_data == pistol_weapon:
			weapon.set_weapon_data(shotgun_weapon)
		else:
			weapon.set_weapon_data(pistol_weapon)

func _on_hotdog_picked(amount: float) -> void:
	stats.heal(amount)
