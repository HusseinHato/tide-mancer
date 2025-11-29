extends DropItem
class_name Magnet

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func collect() -> void:
	Events.magnet_collected.emit()
	queue_free()

func _ready():
	super._ready()
	animated_sprite.play("default")
