extends Node
class_name UpgradeManager

@export var available_upgrades: Array[UpgradeData] = []
@export var upgrade_ui: UpgradeUI
@export var player: Player
#@export var level_up_sound: AudioStream

var _upgrade_levels: Dictionary = {}
var stats: Stats
var _pending_upgrades: int = 0

func _ready() -> void:
	Events.leveled_up.connect(_on_leveled_up)
	if player:
		if player.has_node("Stats"):
			stats = player.get_node("Stats")
	
	upgrade_ui.upgrade_selected.connect(_on_upgrade_selected)

func _on_leveled_up(_new_level: int) -> void:
	_pending_upgrades += 1
	
	#var choices = _pick_upgrade_choices()
	#if choices.is_empty():
		#print("No Upgrades Available")
		#return
	#
	#upgrade_ui.show_choices(choices)
	
	if _pending_upgrades == 1:
		_show_upgrade_options()

func _show_upgrade_options() -> void:
	var choices = _pick_upgrade_choices()
	if choices.is_empty():
		print("No Upgrade Available")
		_pending_upgrades = 0
		return
	
	upgrade_ui.show_choices(choices)

func _pick_upgrade_choices() -> Array[UpgradeData]:
	if !player:
		return []
	
	var eligible: Array[UpgradeData] = []
	
	for up in available_upgrades:
		var current_level: int = _upgrade_levels.get(up.id, 0)
		if current_level < up.max_level:
			eligible.append(up)
	
	if eligible.is_empty():
		return []
	
	var rng = RandomNumberGenerator.new()
	rng. randomize()
	
	eligible.shuffle()
	var count = min(3, eligible.size())
	return eligible.slice(0, count)

func _on_upgrade_selected(upgrade: UpgradeData) -> void:
	if !player:
		return

	var prev_level: int = _upgrade_levels.get(upgrade.id, 0)
	var new_level := prev_level + 1
	_upgrade_levels[upgrade.id] = new_level
	
	upgrade.apply_upgrade(stats, player, new_level)
	
	print("Upgrade chosen: %s (level %d)" % [upgrade.name, new_level])
	
	_pending_upgrades -= 1
	
	if _pending_upgrades > 0:
		_show_upgrade_options()
	else:
		upgrade_ui.close()
