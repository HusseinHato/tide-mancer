extends Area2D

func _ready() -> void:
	area_entered.connect(_on_magnet_area_area_entered)

func _on_magnet_area_area_entered(area: ExperienceGem):
	if area.has_method("start_magnet"):
		area.start_magnet(self)
