extends CanvasLayer

@onready var resume_btn = %Resume
@onready var restart_btn = %Restart
@onready var menu_btn = %MainMenu

@onready var max_health_label: Label = %MaxHealth
@onready var defense_label: Label = %Defense
@onready var attack_label: Label = %Attack
@onready var evasion_label: Label = %Evasion
@onready var move_speed_label: Label = %MoveSpeed
@onready var crit_chance_label: Label = %CriticalChance
@onready var crit_dmg_label: Label = %CriticalDamage
@onready var projectile_size_label: Label = %ProjectileSize
@onready var fire_rate_label: Label = %FireRate
@onready var projectile_count_label: Label = %ProjectileCount
@onready var piercing_count_label: Label = %PiercingCount

@export var player: Player

const MAIN_MENU_PATH = "res://scene/ui/main_menu.tscn"

func _ready() -> void:
	visible = false
	
	resume_btn.pressed.connect(_on_resume_button_pressed)
	restart_btn.pressed.connect(_on_restart_button_pressed)
	menu_btn.pressed.connect(_on_menu_button_pressed)
	_set_stats_info()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if visible:
			_on_resume_button_pressed()
		else:
			pause_game()

func pause_game() -> void:
	_set_stats_info()
	SoundManager.duck_music(-22.0)
	visible = true
	get_tree().paused = true

func _on_resume_button_pressed():
	_set_stats_info()
	SoundManager.unduck_music(-10.0)
	visible = false
	get_tree().paused = false

func _on_menu_button_pressed():
	# The SceneTransition script will handle unpausing, 
	# but strictly speaking, it's cleaner to unpause before asking for a switch
	# (though our updated transition script handles it safely).
	SoundManager.stop_music()
	SceneTransition.change_scene(MAIN_MENU_PATH)

func _on_restart_button_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _set_stats_info() -> void:
	if player.stats:
		max_health_label.text = "Max Health: %.1f" % player.stats.get_max_health() 
		defense_label.text = "Defense: %.1f" % player.stats.get_defense() 
		attack_label.text = "Attack Damage: %.1f" % player.stats.get_attack() 
		evasion_label.text = "Evasion Rate: %d%%" % (player.stats.get_evasion() * 100)
		move_speed_label.text = "Movement Speed: %.1f" % player.stats.get_move_speed() 
		crit_chance_label.text = "Critical Chance: %d%%" % (player.stats.get_crit_chance() * 100)
		crit_dmg_label.text = "Critical Damage: %d%%" % (player.stats.get_crit_dmg() * 100)
		projectile_size_label.text = "Projectile Size: %d%%" % (player.stats.get_projectile_size() * 100)
		fire_rate_label.text = "Fire Rate: %d%%" % (player.stats.get_fire_rate() * 100)
		projectile_count_label.text = "Bonus Projectile Count: %d" % (player.stats.get_projectile_count())
		piercing_count_label.text = "Piercing Count: %d" % (player.stats.get_piercing_count())
