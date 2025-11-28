extends CanvasLayer
class_name  UpgradeUI

signal upgrade_selected(upgrade: UpgradeData)

const UPGRADE_OPTION_SCENE = preload("uid://rcp074axgpew")

@onready var options_container: HBoxContainer = %OptionsContainer
@onready var title_label: Label = %TitleLabel

var _is_open: bool = false

func _ready() -> void:
	visible = false

func show_choices(choices: Array[UpgradeData]) -> void:
	_is_open = true
	visible = true
	
	get_tree().paused = true
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	title_label.text = "Choose an Upgrade"
	_clear_options()
	
	for upgrade in choices:
		var card = UPGRADE_OPTION_SCENE.instantiate() as UpgradeOption
		options_container.add_child(card)
		
		card.clicked.connect(_on_option_pressed)
		card.set_data(upgrade)
		
	
func _clear_options() -> void:
	for child in options_container.get_children():
		child.queue_free()

func _on_option_pressed(upgrade: UpgradeData) -> void:
	if not _is_open:
		return
	
	close()
	
	upgrade_selected.emit(upgrade)

func close() -> void:
	_is_open = false
	visible = false
	get_tree().paused = false
