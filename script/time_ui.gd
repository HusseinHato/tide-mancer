extends Control

@onready var time_label: Label = $TimerLabel

var time_elapsed: float = 0.0
var is_running: bool = true

func _process(delta: float) -> void:
	if is_running: 
		time_elapsed += delta
		_update_timer_display()

func _update_timer_display() -> void:
	# Calculate minutes and seconds
	# floor() ensures we round down to the nearest whole number
	var minutes: int = floor(time_elapsed / 60)
	var seconds: int = int(time_elapsed) % 60
	var milliseconds: int = int((time_elapsed - int(time_elapsed)) * 100)
	
	time_label.text = "%02d:%02d:%02d" % [minutes, seconds, milliseconds]
