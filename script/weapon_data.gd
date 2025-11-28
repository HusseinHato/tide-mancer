extends Resource
class_name WeponData

@export var name: String = ""
@export var bullet_scene: PackedScene
@export var base_damage: float = 5.0
@export var fire_rate: float = 2.0
@export var bullets_per_shot: int = 1
@export var spred_deg: float = 0.0
@export var projectile_speed: float = 400.0
@export var weapon_sprite: Texture2D
