extends EnemyState
class_name StateDash

@export_group("Dash Settings")
@export var charge_time: float = 0.3
@export var lock_time: float = 0.2
@export var dash_speed: float = 450
@export var dash_duration: float = 0.4
@export var cancel_dash_radius: float = 200.0

@export_group("Telegraph Visuals")
@export var telegraph_color: Color = Color(1, 0, 0, 0.5)
@export var telegraph_width: float = 10.0
@export var telegraph_length = 200.0

var timer: float = 0.0
var dash_direction: Vector2
var is_dashing: bool = false
var telegraph_line: Line2D
var charge_tween: Tween

func _ready() -> void:
	# Create the Visual line programmatically
	telegraph_line = Line2D.new()
	telegraph_line.width = telegraph_width
	telegraph_line.default_color = telegraph_color
	telegraph_line.visible = false
	
	call_deferred("_setup_line")

func _setup_line() -> void:
	if enemy:
		enemy.add_child(telegraph_line)

func enter() -> void:
	enemy.velocity = Vector2.ZERO
	timer = charge_time
	is_dashing = false
	
	if telegraph_line:
		telegraph_line.visible = true
		telegraph_line.width = 0.0
		telegraph_line.modulate.a = 0.0
		
		if charge_tween: 
			charge_tween.kill()
		charge_tween = create_tween()
		charge_tween.set_parallel(true)
		charge_tween.tween_property(telegraph_line, "width", telegraph_width, charge_time)
		charge_tween.tween_property(telegraph_line, "modulate:a", 1.0, charge_time)
		
	if enemy.player:
		dash_direction = enemy.global_position.direction_to(enemy.player.global_position)
		_update_telegraph()

func exit() -> void:
	if telegraph_line:
		telegraph_line.visible = false
	if charge_tween:
		charge_tween.kill()

func _update_telegraph() -> void:
	if !telegraph_line:
		return
	
	telegraph_line.points = [Vector2.ZERO, dash_direction * telegraph_length]

func physics_update(delta: float) -> void:
	timer -= delta
	
	enemy.animated_sprite2d.flip_h = dash_direction.x >= 0 
	
	if !is_dashing:
		if enemy.player:
			var dist = enemy.global_position.distance_to(enemy.player.global_position)
			
			if dist > cancel_dash_radius:
				state_machine.change_state("StateChase")
				return
			
			if timer > lock_time:
				dash_direction = enemy.global_position.direction_to(enemy.player.global_position)
				_update_telegraph()
		
		if timer <= 0:
			_start_dash()
	else:
		enemy.velocity = enemy.velocity.move_toward(dash_direction * dash_speed, dash_speed * 5 * delta)
		#enemy.velocity = dash_direction * dash_speed
		if timer <= 0:
			state_machine.change_state("StateChase")

func _start_dash() -> void:
	is_dashing = true
	timer = dash_duration
	
	if telegraph_line:
		telegraph_line.visible = false
