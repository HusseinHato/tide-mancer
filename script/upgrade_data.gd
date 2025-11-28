extends Resource
class_name UpgradeData

@export var id: StringName
@export var name: String
@export_multiline var description: String
@export var icon: Texture2D
@export var max_level: int

func apply_upgrade(stats: Stats, player: Player, new_level: int) -> void:
	pass
