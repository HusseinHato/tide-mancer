extends Node

var num_players: int = 12
var num_players_2d: int = 32
var default_bus: String = "SFX"
var music_bus: String = "Music" # New config for Music Bus

var available_players: Array[AudioStreamPlayer] = []
var queue: Array[AudioStreamPlayer] = []

var available_players_2d: Array[AudioStreamPlayer2D] = []
var queue_2d: Array[AudioStreamPlayer2D] = []

var sound_cooldowns: Dictionary = {}
const SAME_SOUND_LIMIT_MS: int = 50

var music_player: AudioStreamPlayer
var music_tween: Tween

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
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
	
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	music_player.bus = music_bus

# --- Volume Settings (NEW) ---
# value: 0.0 to 1.0 (Linear). We convert this to Decibels automatically.
func change_volume(bus_name: String, value: float) -> void:
	var bus_index = AudioServer.get_bus_index(bus_name)
	if bus_index == -1:
		push_warning("SoundManager: Bus '%s' not found." % bus_index)
		return
	
	if value <= 0.05:
		AudioServer.set_bus_mute(bus_index, true)
	else:
		AudioServer.set_bus_mute(bus_index, false)
		# linear_to_db converts 0.5 to -6dB, etc
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))

# Gets the current linear volume (0.0 to 1.0) for UI sliders
func get_volume(bus_name: String) -> float:
	var bus_index = AudioServer.get_bus_index(bus_name)
	if bus_index == -1: return 1.0
	
	if AudioServer.is_bus_mute(bus_index):
		return 0.0
	
	var db = AudioServer.get_bus_volume_db(bus_index)
	return db_to_linear(db)

# --- MUSIC FUNCTIONS (NEW) ---

func play_music(stream: AudioStream, volume_db: float = 0.0, fade_duration: float = 1.0):
	if stream == null: return
	
	# If the same song is already playing, just ensure volume is correct
	if music_player.stream == stream and music_player.playing:
		unduck_music(volume_db, 0.5)
		return

	# If a different song is playing, or nothing is playing
	music_player.stream = stream
	music_player.volume_db = -80 # Start silent
	music_player.play()
	
	_tween_music_volume(volume_db, fade_duration)

func stop_music(fade_duration: float = 1.0):
	# Fade out then stop
	if music_tween: music_tween.kill()
	music_tween = create_tween()
	music_tween.tween_property(music_player, "volume_db", -80.0, fade_duration)
	music_tween.tween_callback(music_player.stop)

# Call this when Upgrade Screen opens
func duck_music(target_db: float = -15.0, duration: float = 0.5):
	_tween_music_volume(target_db, duration)

# Call this when Upgrade Screen closes
func unduck_music(target_db: float = 0.0, duration: float = 0.5):
	_tween_music_volume(target_db, duration)

func _tween_music_volume(target_db: float, duration: float):
	if music_tween: music_tween.kill()
	music_tween = create_tween()
	# TransitionType.TRANS_SINE makes it sound smoother
	music_tween.set_trans(Tween.TRANS_SINE) 
	music_tween.tween_property(music_player, "volume_db", target_db, duration)

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
