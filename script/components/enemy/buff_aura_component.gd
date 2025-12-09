extends Area2D
class_name BuffAuraComponent

@onready var apply_buff_timer: Timer = $ApplyBuffTimer

@export var tick_rate: float = 1.0

@export var status_effect: StatusEffect

@export_group("Visual Indicator")
@export var show_visual: bool = true
@export var radius: float = 120.0
@export var outline_color: Color = Color(0.679, 0.823, 0.996, 0.6)
@export var outline_width: float = 2.5

func _ready() -> void:
	apply_buff_timer.wait_time = tick_rate
	apply_buff_timer.timeout.connect(_on_buff_tick)
	
	queue_redraw()

func _on_buff_tick() -> void:
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body is Enemy and body != owner:
			if body.is_buffer:
				return
			if body.has_node("StatusController"):
				var status_controller = body.get_node("StatusController") as StatusController
				status_controller.apply_effect(status_effect)

func _draw() -> void:
	if show_visual:
		draw_arc(Vector2.ZERO, radius, 0, TAU, 32, outline_color, outline_width)
