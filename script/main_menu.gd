extends Control

const GAME_SCENE_PATH = "res://scene/sea.tscn"

const SETTINGS_SCENE_PATH = "res://scene/settings_menu.tscn"

const BUTTON_HOVER_SOUND = preload("uid://kurfr6tpn2h1")
const BUTTON_PLAY_SOUND = preload("uid://cq18lu6hjyil")

@onready var play_btn: Button = %Play
@onready var exit_btn: Button = %Exit
@onready var settings_btn: Button = %Settings
@onready var settings_menu: Control = $SettingsMenu

const MAIN_MENU_SOUND = preload("uid://bmtywrq2ft1mg")

func _ready() -> void:
	SoundManager.play_music(MAIN_MENU_SOUND, -7.0, 1.0)
	
	play_btn.pressed.connect(_on_play_pressed)
	play_btn.mouse_entered.connect(_on_button_hovered)
	
	exit_btn.pressed.connect(_on_exit_pressed)
	exit_btn.mouse_entered.connect(_on_button_hovered)
	
	settings_btn.pressed.connect(_on_settings_pressed)
	settings_btn.mouse_entered.connect(_on_button_hovered)

func _on_play_pressed() -> void:
	SoundManager.play_ui(BUTTON_PLAY_SOUND, -10)
	SoundManager.stop_music(0.5)
	SceneTransition.change_scene(GAME_SCENE_PATH)
	#get_tree().change_scene_to_file(GAME_SCENE_PATH)

func _on_settings_pressed() -> void:
	SoundManager.play_ui(BUTTON_PLAY_SOUND, -18)
	settings_menu.show()

func _on_exit_pressed() -> void:
	SoundManager.play_ui(BUTTON_PLAY_SOUND, -18)
	get_tree().quit()

func _on_button_hovered() -> void:
	SoundManager.play_ui(BUTTON_HOVER_SOUND, -18)
