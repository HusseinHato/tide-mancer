extends Control

@onready var master_slider: HSlider = %MasterSlider
@onready var music_slider: HSlider = $%MusicSlider
@onready var sfx_slider: HSlider = %SFXSlider
@onready var close_button: Button = %BackButton

const UI_CLICK_SOUND = preload("uid://kurfr6tpn2h1")

func _ready() -> void:
	master_slider.value = SoundManager.get_volume("Master")
	music_slider.value = SoundManager.get_volume("Music")
	sfx_slider.value = SoundManager.get_volume("SFX")
	
	master_slider.value_changed.connect(_on_master_slider_value_changed)
	music_slider.value_changed.connect(_on_music_slider_value_changed)
	sfx_slider.value_changed.connect(_on_sfx_slider_value_changed)
	
	close_button.pressed.connect(_on_close_pressed)

func _on_master_slider_value_changed(value: float) -> void:
	SoundManager.change_volume("Master", value)

func _on_music_slider_value_changed(value: float) -> void:
	SoundManager.change_volume("Music", value)

func _on_sfx_slider_value_changed(value: float) -> void:
	SoundManager.change_volume("SFX", value)
	
	SoundManager.play_ui(UI_CLICK_SOUND, -18)

func _on_close_pressed() -> void:
	hide()
