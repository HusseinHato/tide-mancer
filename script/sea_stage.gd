extends Node2D

@onready var game_over_screen: GameOver = %GameOver
@onready var player: Player = %Player

func _ready() -> void:
	player.player_dead.connect(_on_player_died)

func _on_player_died() -> void:
	game_over_screen.set_game_over(false)
