extends Node
class_name UpgradeManager

@export var available_upgrades: Array[UpgradeData] = []
@export var upgrade_ui: UpgradeUI
@export var player: Player

@export var collected_upgrades_container: HBoxContainer
@export var upgrade_badge_scene: PackedScene

var _upgrade_levels: Dictionary = {}
var _active_badges: Dictionary = {}

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
	
	_update_hud_badge(upgrade, new_level)
	
	_pending_upgrades -= 1
	
	if _pending_upgrades > 0:
		_show_upgrade_options()
	else:
		upgrade_ui.close()

# Helper function to handle the UI logic
func _update_hud_badge(upgrade: UpgradeData, level: int) -> void:
	if not collected_upgrades_container or not upgrade_badge_scene:
		return

	# If we already have a badge for this upgrade, just update the number
	if _active_badges.has(upgrade.id):
		var existing_badge = _active_badges[upgrade.id]
		existing_badge.update_level(level)
	else:
		# Otherwise, create a new badge
		var new_badge = upgrade_badge_scene.instantiate()
		collected_upgrades_container.add_child(new_badge)
		new_badge.set_data(upgrade, level)
		
		# Store reference for next time
		_active_badges[upgrade.id] = new_badge
