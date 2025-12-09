extends Area2D
class_name MagnetArea

func _ready() -> void:
	area_entered.connect(_on_magnet_area_area_entered)

func _on_magnet_area_area_entered(area: Area2D):
	if area.has_method("start_magnet"):
		area.start_magnet(self)
