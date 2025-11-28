extends Node
class_name ExperienceManager

@export var base_xp_to_level: int = 30
@export var xp_growth_per_level: int = 20

signal xp_added(current_xp: int, xp_to_next: int)

var level: int = 1
var current_xp: int = 0;
var xp_to_next: int

func _ready() -> void:
	xp_to_next = base_xp_to_level
	Events.xp_collected.connect(_on_xp_collected)

func add_xp(amount: int) -> void:
	current_xp += amount
	
	while current_xp >= xp_to_next:
		current_xp -= xp_to_next
		_level_up()
	
	xp_added.emit(current_xp, xp_to_next)

func _level_up() -> void:
	level += 1
	xp_to_next = base_xp_to_level + (level - 1) * xp_growth_per_level
	Events.leveled_up.emit(level)
	print("Level Up! Now Level %s" % level)
	print(xp_to_next)

func _on_xp_collected(amount: int) -> void:
	add_xp(amount)
