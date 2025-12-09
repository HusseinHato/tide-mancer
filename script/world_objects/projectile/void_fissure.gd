extends Area2D
class_name VoidFissure

var damage: float = 1.0
var tick_rate: float = 0.5
var duration: float = 4.0

@onready var tick_timer: Timer = $TickTimer
@onready var life_timer: Timer = $LifetimeTimer

func _ready() -> void:
	
	tick_timer.wait_time = tick_rate
	tick_timer.timeout.connect(_on_tick)
	tick_timer.start()
	
	life_timer.wait_time = duration
	life_timer.timeout.connect(queue_free)
	life_timer.start()

func _on_tick() -> void:
	var areas = get_overlapping_areas()
	for area in areas:
		if area.get_parent().has_node("Stats"):
			var target_stats = area.get_parent().get_node("Stats")
			target_stats.take_damage(damage, "normal")
