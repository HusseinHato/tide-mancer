extends CanvasLayer
class_name DeathSequence

@onready var black_screen = $BlackScreen
@onready var fake_player = $CenterPoint/CharSprite
@onready var continue_btn = $ContinueButton
@onready var ui_container = $UIContainer

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	ui_container.modulate.a = 0.0
	continue_btn.pressed.connect(_on_continue_pressed)
	
	(black_screen.material as ShaderMaterial).set_shader_parameter("circle_size", 1.5)
	
	fake_player.visible = false

func start_death_sequence() -> void:
	get_tree().paused = true
	
	var tween = create_tween()
	tween.set_parallel(true)
	
	fake_player.visible = true
	
	tween.tween_method(
		func(val): (black_screen.material as ShaderMaterial).set_shader_parameter("circle_size", val),
		1.5, 0.0, 1.0
	)
	
	
	tween.tween_property(fake_player, "scale", Vector2(4, 4), 1.5).set_trans(Tween.TRANS_CUBIC)
	
	await get_tree().create_timer(1.2).timeout
	
	var ui_tween = create_tween()
	ui_tween.tween_property(ui_container, "modulate:a", 1.0, 0.5)

func _on_continue_pressed():
	get_tree().paused = false
	visible = false
	get_tree().change_scene_to_file("res://scene/ui/main_menu.tscn")
