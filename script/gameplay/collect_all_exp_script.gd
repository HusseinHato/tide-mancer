extends Node2D
class_name CollectAllExp

@export var player: Player

var magnet_area: MagnetArea

func _ready() -> void:
	Events.magnet_collected.connect(_on_magnet_collected)

func _on_magnet_collected() -> void:
	if !player:
		return
	
	if player.has_node("MagnetArea"):
		magnet_area = player.get_node("MagnetArea")
	
	for child in get_children():
		if child.has_method("start_magnet"):
			child.start_magnet(magnet_area)
