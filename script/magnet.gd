extends DropItem
class_name Magnet

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var pickup_sound: AudioStream

func collect() -> void:
	Events.magnet_collected.emit()
	SoundManager.play_player_sfx(pickup_sound, -15.5)
	queue_free()

func _ready():
	super._ready()
	animated_sprite.play("default")
