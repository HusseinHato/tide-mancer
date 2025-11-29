extends Node
class_name DropComponent

var dropable_item = {
	"normal_exp": preload("uid://cdidaf5xsujf3"),
	"greater_exp": preload("uid://bvjfysvwvh8or"),
	"super_exp": preload("uid://7sbfm28tal6e"),
	"hot_dog": preload("uid://3viny15nvpp3"),
	"exp_magnet": preload("uid://ddh5p6un35rv8")
}

@export_group("Chance")
@export var normal_exp_chance: float = 0.83
@export var greater_exp_chance: float = 0.12
@export var super_exp_chance: float = 0.007
@export var hot_dog_chance: float = 0.027
@export var exp_magnet_chance: float = 0.003

var parent_node: Enemy

func _ready() -> void:
	parent_node = owner
	parent_node.enemy_died.connect(_on_parent_dead)

func _on_parent_dead() -> void:
	call_deferred("_perform_drop")

func _perform_drop() -> void:
	if !dropable_item:
		return
	
	var rng := RandomNumberGenerator.new()
	rng.randomize()
	
	var xp_item: PackedScene
	
	var xp_chance: float = randf()
	var hot_dog_drop_chance: float = randf()
	var magnet_chance: float = randf()
	
	if hot_dog_drop_chance < hot_dog_chance:
		var hottu_dogu = dropable_item["hot_dog"] as PackedScene
		var hot_dog_instance = hottu_dogu.instantiate() as HotDog
		hot_dog_instance.global_position = parent_node.global_position
		get_tree().current_scene.get_node("Entities").add_child(hot_dog_instance)
	
	if magnet_chance < exp_magnet_chance:
		var magnetu = dropable_item["exp_magnet"] as PackedScene
		var magnet_instance = magnetu.instantiate() as Magnet
		magnet_instance.global_position = parent_node.global_position
		get_tree().current_scene.get_node("Entities").add_child(magnet_instance)
	
	# Exp
	if xp_chance > normal_exp_chance:
		return
	if xp_chance < normal_exp_chance:
		xp_item = dropable_item["normal_exp"]
	if xp_chance < greater_exp_chance:
		xp_item = dropable_item["greater_exp"]
	if xp_chance < super_exp_chance:
		xp_item = dropable_item["super_exp"]
	
	var xp_item_instance = xp_item.instantiate() as ExperienceGem
	xp_item_instance.global_position = parent_node.global_position
	get_tree().current_scene.get_node("Entities/Exp").add_child(xp_item_instance)
