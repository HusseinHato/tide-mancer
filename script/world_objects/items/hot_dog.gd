extends DropItem
class_name HotDog

@export var heal_amount: float = 20.0
@export var pickup_sound: AudioStream

func collect() -> void:
	Events.hot_dog_picked.emit(heal_amount)
	SoundManager.play_player_sfx(pickup_sound, 0.0)
	queue_free()
