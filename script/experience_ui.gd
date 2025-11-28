extends Control

@onready var xp_indicator: TextureProgressBar = $ExperienceIndicator
@onready var numerical_indicator: Label = $NumericalIndicator

@export var experience_manager: ExperienceManager

func _ready() -> void:
	if experience_manager:
		experience_manager.xp_added.connect(_on_xp_added)
		_on_xp_added(experience_manager.current_xp, experience_manager.base_xp_to_level)
	Events.leveled_up.connect(_on_level_up)

func _on_xp_added(current_xp: int, xp_to_next: int) -> void:
	xp_indicator.max_value = xp_to_next
	xp_indicator.value = current_xp

func _on_level_up(level: int) -> void:
	numerical_indicator.text = "Lv. %s" % level
