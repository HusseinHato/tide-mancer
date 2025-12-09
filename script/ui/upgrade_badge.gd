extends Control
class_name UpgradeBadge

@onready var icon_rect: TextureRect = $TextureRect
@onready var name_label: Label = %LabelName
@onready var lvl_label: Label = %LabelLevel

func set_data(upgrade: UpgradeData, level: int) -> void:
	icon_rect.texture = upgrade.icon
	name_label.text = upgrade.name
	update_level(level)

func update_level(new_level: int) -> void:
	lvl_label.text = "Lvl %d" % new_level
