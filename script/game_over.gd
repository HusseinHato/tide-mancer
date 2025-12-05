extends CanvasLayer
class_name GameOver

@onready var title_label: Label = %TitleLabel
@onready var restart_button: Button = %RestartButton
@onready var main_menu_button: Button = %MainMenuButton
@onready var background: ColorRect = %Background
@onready var label: Label = %Stats
@export var timer_related: Control

const MAIN_MENU_PATH = "res://scene/main_menu.tscn"

func _ready() -> void:
	visible = false
	
	SoundManager.stop_music(2.0)
	
	restart_button.pressed.connect(_on_restart_pressed)
	main_menu_button.pressed.connect(_on_main_menu_pressed)
	
func set_game_over(is_win: bool) -> void:
	visible = true
	
	if is_win:
		background.color = Color.LIGHT_GREEN
		title_label.text = "YOU WIN!"
		title_label.modulate = Color.GREEN
		restart_button.visible = false
	else:
		background.color = Color(0.698, 0.133, 0.133, 0.533)
		title_label.text = "GAME OVER"
		title_label.modulate = Color.RED
	
	main_menu_button.visible = true
	
	var minutes_and_second: Array[int] = timer_related.get_time_elapsed()
	var minute = minutes_and_second[0]
	var second = minutes_and_second[1]
	
	label.text = "You Survived for : %d Minutes %d Seconds " % [minute, second]
	
	#get_tree().paused = true

func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_main_menu_pressed() -> void:
	SceneTransition.change_scene(MAIN_MENU_PATH)
