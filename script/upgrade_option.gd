extends Button
class_name UpgradeOption

signal clicked(upgrade_data: UpgradeData)

@onready var name_label: Label = %NameLabel
@onready var desc_label: Label = %DescLabel
@onready var icon_rect: TextureRect = %IconRect

var _data: UpgradeData

func set_data(upgrade: UpgradeData) -> void:
	_data = upgrade
	name_label.text = upgrade.name
	desc_label.text = upgrade.description
	
	if upgrade.icon:
		icon_rect.texture = upgrade.icon
		icon_rect.visible = true
	else:
		icon_rect.visible = false

func _ready() -> void:
	pressed.connect(_on_pressed)
	mouse_entered.connect(_on_mouse_entered)
	mouse_entered.connect(_on_mouse_exited)

func _on_pressed() -> void:
	clicked.emit(_data)

func _on_mouse_entered() -> void:
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.05, 1.05), 0.1)

func _on_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.1)
