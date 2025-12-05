extends CanvasLayer

@onready var color_rect = $ColorRect

func _ready() -> void:
	var material = color_rect.material as ShaderMaterial
	material.set_shader_parameter("circle_size", 0.0)
	
	await get_tree().create_timer(0.1).timeout
	
	reveal_game()

func reveal_game() -> void:
	var material = color_rect.material as ShaderMaterial
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_method(
		func(value): material.set_shader_parameter("circle_size", value),
		0.0,
		1.2,
		2.0
	)
	
	tween.finished.connect(queue_free)
