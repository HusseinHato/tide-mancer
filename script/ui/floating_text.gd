extends Label
class_name FloatingText

@export var float_speed: Vector2 = Vector2(0, -60)
@export var fade_duration: float = 1.5

func _ready() -> void:
	# Random Horizontal Movement
	float_speed.x = randf_range(-20.0, 20.0)
	
	# Create a tween (animation)
	var tween = create_tween()
	
	# Run these two animations in parallel
	tween.set_parallel(true)
	
	
	# Text go upwards
	var final_position = position + (float_speed * fade_duration)
	tween.tween_property(self, "position", final_position, fade_duration).set_ease(Tween.EASE_OUT)
	
	#if crit:
		#tween.tween_property(self, "scale", Vector2(2, 2), 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	#else:
		#tween.tween_property(self, "scale", Vector2(0.7, 0.7), 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	
	# Fade out
	tween.tween_property(self, "modulate:a", 0.0, fade_duration).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	
	tween.set_parallel(false)
	tween.tween_callback(queue_free)
