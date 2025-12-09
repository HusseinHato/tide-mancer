extends CanvasLayer

@onready var color_rect = $ColorRect
@onready var animation_player = $AnimationPlayer

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func change_scene(target_path: String) -> void:
	color_rect.mouse_filter = Control.MOUSE_FILTER_STOP
	
	animation_player.play("dissolve")
	await animation_player.animation_finished
	
	get_tree().paused = false
	get_tree().change_scene_to_file(target_path)
	
	animation_player.play_backwards("dissolve")
	await animation_player.animation_finished
	
	#await get_tree().create_timer(1.0).timeout
	
	#get_tree().paused = false
	color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
