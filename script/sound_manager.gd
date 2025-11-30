extends Node

var num_players: int = 12
var num_players_2d: int = 32
var default_bus: String = "SFX"

var available_players: Array[AudioStreamPlayer] = []
var queue: Array[AudioStreamPlayer] = []

var available_players_2d: Array[AudioStreamPlayer2D] = []
var queue_2d: Array[AudioStreamPlayer2D] = []

var sound_cooldowns: Dictionary = {}
const SAME_SOUND_LIMIT_MS: int = 50

func _ready() -> void:
	for i in range(num_players):
		var p = AudioStreamPlayer.new()
		add_child(p)
		available_players.append(p)
		p.finished.connect(_on_stream_finished.bind(p))
		p.bus = default_bus
	
	for i in range(num_players_2d):
		var p = AudioStreamPlayer2D.new()
		add_child(p)
		available_players_2d.append(p)
		p.finished.connect(_on_stream_finished_2d.bind(p))
		p.bus = default_bus
		
		p.max_distance = 1300
		p.attenuation = 1.5

func play_sfx_2d(stream: AudioStream, global_pos: Vector2, pitch_min: float = 0.9, pitch_max: float = 1.1, volume_db: float = 0.0, specific_bus: String = "") -> void:
	if stream == null: 
		return
	if _check_cooldown(stream):
		return
	
	var player = _get_player_2d()
	
	player.global_position = global_pos
	player.stream = stream
	player.pitch_scale = randf_range(pitch_min, pitch_max)
	player.volume_db = volume_db
	player.bus = specific_bus if specific_bus != "" else default_bus
	
	player.play()

func play_sfx(stream: AudioStream, pitch_min: float = 0.9, pitch_max: float = 1.1, volume_db: float = 0.0, specific_bus: String = "") -> void:
	if stream == null: 
		return
	if _check_cooldown(stream):
		return
	
	var player = _get_player()
	
	player.stream = stream
	player.pitch_scale = randf_range(pitch_min, pitch_max)
	player.volume_db = volume_db
	player.bus = specific_bus if specific_bus != "" else default_bus
	
	player.play()

func play_ui(stream: AudioStream, volume_db: float = 0.0):
	play_sfx(stream, 1.0, 1.0, volume_db, "UI")

func play_player_sfx(stream: AudioStream, volume_db: float = 0.0):
	play_sfx(stream, 0.9, 1.1, volume_db, "Player")

func play_world_sfx(stream: AudioStream, location: Vector2, volume_db: float = 0.0):
	play_sfx_2d(stream, location, 0.8, 1.2, volume_db, "World")

func _check_cooldown(stream: AudioStream) -> bool:
	var now = Time.get_ticks_msec()
	var stream_id = stream.get_instance_id()
	if sound_cooldowns.has(stream_id):
		if now - sound_cooldowns[stream_id] < SAME_SOUND_LIMIT_MS:
			return true
	sound_cooldowns[stream_id] = now
	return false 

func _get_player() -> AudioStreamPlayer:
	if available_players.size() > 0:
		var p = available_players.pop_back()
		queue.append(p)
		return p
	else:
		var p = queue.pop_front()
		p.stop()
		queue.append(p)
		return p

func _get_player_2d() -> AudioStreamPlayer2D:
	if available_players_2d.size() > 0:
		var p = available_players_2d.pop_back()
		queue_2d.append(p)
		return p
	else:
		var p = queue_2d.pop_front()
		p.stop()
		queue_2d.append(p)
		return p

func _on_stream_finished(player: AudioStreamPlayer) -> void:
	if player in queue:
		queue.erase(player)
		available_players.append(player)

func _on_stream_finished_2d(player: AudioStreamPlayer2D) -> void:
	if player in queue_2d:
		queue_2d.erase(player)
		available_players_2d.append(player)

func _process(_delta: float) -> void:
	if Engine.get_frames_drawn() % 600 == 0:
		var now = Time.get_ticks_msec()
		var keys_to_remove = []
		for k in sound_cooldowns:
			if now - sound_cooldowns[k] > 1000:
				keys_to_remove.append(k)
		for k in keys_to_remove:
			sound_cooldowns.erase(k)
