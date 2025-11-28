extends Node2D
class_name Weapon

@export var weapon_data: WeponData
@export var orbit_radius: float = 27.0
@export var rotate_weapon_sprite: bool = true

@onready var stats: Stats = get_parent().get_node("Stats")
@onready var sprite: Sprite2D = $Sprite2D
@onready var muzzle: Marker2D = $Sprite2D/Muzzle
@onready var shoot_timer: Timer = $ShootTimer

var can_shoot: bool = true

func _ready() -> void:
	if not weapon_data:
		push_error("Weapon: No weapon assigned!")
		return
	
	shoot_timer.timeout.connect(_on_shoot_timer_timeout)

func _process(_delta: float) -> void:
	if not weapon_data:
		return
	
	var mouse_pos = get_global_mouse_position()
	var player_pos = get_parent().global_position
	var angle_to_mouse = player_pos.angle_to_point(mouse_pos)
	
	position = Vector2(orbit_radius, 0).rotated(angle_to_mouse)
	
	if rotate_weapon_sprite and sprite:
		var direction_to_mouse := (mouse_pos - global_position).angle()
		sprite.rotation = direction_to_mouse
		
		if abs(direction_to_mouse) > PI / 2:
			sprite.flip_v = true
		else:
			sprite.flip_v = false
	
	shoot()

func shoot() -> void:
	if not can_shoot or not weapon_data or not weapon_data.bullet_scene:
		return
	
	can_shoot = false
	#var current_fire_rate = (1.2 / stats.get_fire_rate()) + weapon_data.fire_rate
	shoot_timer.start((1.2 / stats.get_fire_rate()) + weapon_data.fire_rate)
	
	var mouse_pos = get_global_mouse_position()
	var spawn_pos = muzzle.global_position if muzzle else global_position
	var direction = (mouse_pos - spawn_pos).normalized()
	
	for i in range(weapon_data.bullets_per_shot + stats.get_projectile_count()):
		_spawn_bullet(direction, spawn_pos, i)

func _spawn_bullet(base_direction: Vector2, spawn_position: Vector2, bullet_index: int) -> void:
	var bullet = weapon_data.bullet_scene.instantiate() as Bullet
	
	var spread_offset: float = 0.0
	if weapon_data.bullets_per_shot > 1:
		var spread_step := weapon_data.spred_deg / (weapon_data.bullets_per_shot - 1) if weapon_data.bullets_per_shot > 1 else 0.0
		spread_offset = -weapon_data.spred_deg / 2.0 + spread_step * bullet_index
	else: 
		spread_offset = randf_range(-weapon_data.spred_deg / 2.0, weapon_data.spred_deg / 2.0)
		
	var spread_rad := deg_to_rad(spread_offset)
	var final_direction := base_direction.rotated(spread_rad)
	
	var final_damage := weapon_data.base_damage
	if stats:
		final_damage *= stats.get_attack() / stats.base_attack
		
		if randf() < stats.get_crit_chance():
			bullet.critical_hit = true
			final_damage *= stats.get_crit_dmg()
	
	var final_speed := weapon_data.projectile_speed
	if stats:
		final_speed = stats.get_projectile_speed() + weapon_data.projectile_speed
	
	var final_piercing_count = weapon_data.piercing_count + stats.get_piercing_count()
	
	bullet.global_position = spawn_position
	
	if bullet.has_method("initialize"):
		bullet.initialize(final_direction, final_speed, final_damage, final_piercing_count, stats.get_projectile_size())
	else:
		if "direction" in bullet:
			bullet.direction = final_direction
		if "speed" in bullet:
			bullet.speed = final_speed
		if "damage" in bullet:
			bullet.damage = final_damage
	
	get_tree().root.add_child(bullet)

func _on_shoot_timer_timeout() -> void:
	can_shoot = true

func set_weapon_data(new_weapon_data: WeponData) -> void:
	weapon_data = new_weapon_data
	sprite.texture = new_weapon_data.weapon_sprite
