extends Control

@onready var health_indicator: TextureProgressBar = $HealthIndicator
@onready var numerical_indicator: Label = $NumericalIndicator

@export var player: Node

var player_stats: Stats

func _ready() -> void:
	if player:
		player_stats = player.get_node_or_null("Stats")
		if player_stats:
			player_stats.health_changed.connect(_on_player_health_changed)
			_on_player_health_changed(player_stats.health, player_stats.get_max_health())

func _on_player_health_changed(current_health: float, max_health: float) -> void:
	health_indicator.max_value = max_health
	health_indicator.value = current_health
	var format_string = "%.f / %.f"
	numerical_indicator.text = format_string % [current_health, max_health]
