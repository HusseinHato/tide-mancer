extends CharacterBody2D
class_name Player

signal player_dead

@export var speed: float = 300.0
@export var acceleration: float = 900.0
@export var friction: float = 1200.0

@export var weapon: Weapon

@onready var sprite: Sprite2D = $Sprite2D
@onready var stats: Stats = $Stats

@export var poison_effect: PoisonEffect
@export var haste_effect: HasteEffect
@export var regen_effect: RegenEffect
@export var fire_rate_effect: FireRateEffect

@export var pistol_weapon: WeponData
@export var shotgun_weapon: WeponData

func _ready() -> void:
	stats.health_depleted.connect(died)
	haste_effect.on_haste_apply.connect(_on_haste_applied)
	haste_effect.on_haste_expire.connect(_on_haste_expired)
	
	if has_node("StatusController"):
		var controller: StatusController = get_node("StatusController")
		#controller.apply_effect(poison_effect)
		#controller.apply_effect(haste_effect)
		#controller.apply_effect(regen_effect)
		#controller.apply_effect(fire_rate_effect)

func recalculate_stats() -> void:
	speed = stats.get_move_speed()
	acceleration = speed * 2
	friction = acceleration * 2 

func _on_haste_applied() -> void:
	recalculate_stats()

func _on_haste_expired() -> void:
	recalculate_stats()

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
	player_dead.emit()
	queue_free()

func switch_weapon() -> void:
	if weapon:
		if weapon.weapon_data == pistol_weapon:
			weapon.set_weapon_data(shotgun_weapon)
		else:
			weapon.set_weapon_data(pistol_weapon)
