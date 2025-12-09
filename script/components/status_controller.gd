extends Node
class_name StatusController

@export var stats: Stats
@export var icon_container: HBoxContainer

class ActiveEffect:
	var data: StatusEffect
	var remaining: float
	var tick_timer: float
	var stacks: int = 1
	var icon_node: TextureRect

var _effects: Dictionary = {} # id:StringName -> ActiveEffect

func _ready() -> void:
	set_process(true)

func _process(delta: float) -> void:
	if _effects.is_empty():
		return
	
	var to_remove: Array[StringName] = []
	
	for id in _effects.keys():
		var eff: ActiveEffect = _effects[id]
		
		eff.remaining -= delta
		eff.tick_timer -= delta
		
		# Tick Effect
		if eff.tick_timer <= 0.0:
			eff.tick_timer += eff.data.tick_interval
			if eff.data.tick_interval < 999998.0: # avoid "no tick" ones
				eff.data.on_tick(stats, eff.stacks)
		
		# Expire Effect
		if eff.remaining <= 0.0:
			to_remove.append(id)
	
	for id in to_remove:
		_remove_effect(id)

func apply_effect(effect_data: StatusEffect) -> void:
	if stats == null:
		push_error("StatusController: stats is not assigned!")
		return
		
	var id := effect_data.id
	
	if _effects.has(id):
		var eff: ActiveEffect = _effects[id]
		if eff.stacks < effect_data.max_stacks:
			eff.stacks += 1
			effect_data.on_apply(stats, eff.stacks)
		# Refresh Duration
		eff.remaining = effect_data.duration
		# Optionally reset tick timer:d
		#eff.tick_timer = min(eff.tick_timer, effect_data.tick_interval)
	else:
		var eff := ActiveEffect.new()
		eff.data = effect_data
		eff.remaining = effect_data.duration
		eff.tick_timer = effect_data.tick_interval
		eff.stacks = 1
	
		# Create icon
		if icon_container and effect_data.icon:
			var icon := TextureRect.new()
			icon.texture = effect_data.icon
			icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			icon.custom_minimum_size = Vector2(24,24)
			icon_container.add_child(icon)
			eff.icon_node = icon
		
		_effects[id] = eff
		effect_data.on_apply(stats, eff.stacks)

func _remove_effect(id: StringName) -> void:
	if not _effects.has(id):
		return
	var eff: ActiveEffect = _effects[id]
	
	# Call Expire Hook
	eff.data.on_expire(stats, eff.stacks)
	
	# Remove Icon
	if eff.icon_node and is_instance_valid(eff.icon_node):
		if icon_container and icon_container.is_ancestor_of(eff.icon_node):
			icon_container.remove_child(eff.icon_node)
		eff.icon_node.queue_free()
	
	_effects.erase(id)

func clear_all() -> void:
	for id in _effects.keys():
		_remove_effect(id)
