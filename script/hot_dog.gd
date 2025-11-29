extends DropItem
class_name HotDog

@export var heal_amount: float = 20.0

func collect() -> void:
	Events.hot_dog_picked.emit(heal_amount)
	queue_free()
