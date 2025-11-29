extends DropItem
class_name ExperienceGem

@export var xp_amount: int = 10

func collect() -> void:
	Events.xp_collected.emit(xp_amount)
	queue_free()
