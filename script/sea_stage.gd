extends Node2D

@onready var game_over_screen: GameOver = %GameOver
@onready var player: Player = %Player
@onready var start_label = %StartLabel
@onready var enemy_spawner: EnemySpawner = $EnemySpawner
@onready var wave_spawner: WaveSpawner = $WaveSpawner

@export var bgm_music: AudioStream

func _ready() -> void:
	player.player_dead.connect(_on_player_died)
	
	start_label.visible = true
	start_label.text = "GET READY"
	
	SoundManager.play_music(bgm_music, -10.0, 2.0)
	
	# 2. Run the countdown
	await get_tree().create_timer(1.5, false).timeout
	start_label.text = "3"
	await get_tree().create_timer(1.0, false).timeout
	start_label.text = "2"
	await get_tree().create_timer(1.0, false).timeout
	start_label.text = "1"
	await get_tree().create_timer(1.0, false).timeout
	
	# 3. Start the games
	start_label.text = "GO!"
	
	# 4. Hide label after a moment
	await get_tree().create_timer(0.5, false).timeout
	start_label.visible = false
	
	get_tree().create_timer(0.1).timeout.connect(_on_game_start)

func _on_player_died() -> void:
	game_over_screen.set_game_over(false)
	SoundManager.stop_music(2.5)

func _on_game_start():
	enemy_spawner.can_spawn = true
	wave_spawner.can_spawn = true
