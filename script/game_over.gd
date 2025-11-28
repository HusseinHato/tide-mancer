extends CanvasLayer
class_name GameOver

@onready var title_label: Label = %TitleLabel
@onready var restart_button: Button = %RestartButton
@onready var main_menu_button: Button = %MainMenuButton
@onready var background: ColorRect = %Background

func _ready() -> void:
	visible = false
	
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
		title_label.text = "YOU LOSE"
		title_label.modulate = Color.RED
	
	main_menu_button.visible = true

func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_main_menu_pressed() -> void:
	pass
