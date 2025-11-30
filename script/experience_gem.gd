extends DropItem
class_name ExperienceGem

@export var xp_amount: int = 10
@export var pickup_sound: AudioStream

func collect() -> void:
	Events.xp_collected.emit(xp_amount)
	SoundManager.play_player_sfx(pickup_sound, -12.0)
	queue_free()
