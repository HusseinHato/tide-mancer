extends Node
class_name DeathComponent

# CONFIG
@export var sprite_to_effect: CanvasItem
@export var knockback_rotation: float = 20.0
@export var death_duration: float = 0.3

signal death_completed

func activate_death() -> void:
	var parent = get_parent()
	parent.set_physics_process(false)
	parent.set_process(false)
	
	_disable_collisions(parent)
	
	var tween = create_tween()
	tween.set_parallel(false)
	
	tween.tween_property(sprite_to_effect, "scale", Vector2(1.4, 1.4), 0.1).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	var color_tween = create_tween()
	color_tween.tween_property(sprite_to_effect, "modulate", Color.WHITE, 0.1)
	
	tween.tween_property(sprite_to_effect, "rotation_degrees", randf_range(-knockback_rotation, knockback_rotation), death_duration)
	
	var fade_tween = create_tween()
	fade_tween.tween_interval(0.1)
	fade_tween.tween_property(sprite_to_effect, "modulate:a", 0.0, death_duration)
	
	await  fade_tween.finished
	death_completed.emit()
	parent.queue_free()

func _disable_collisions(node: Node) -> void:
	for child in node.get_children():
		if child is CollisionShape2D or child is CollisionPolygon2D:
			child.set_deferred("disabled", true)
		if child is Area2D:
			for grand_child in child.get_children():
				if grand_child is CollisionShape2D or grand_child is CollisionPolygon2D:
					grand_child.set_deferred("disabled", true)
