extends Node

var music_player: AudioStreamPlayer
var global_sfx_player: AudioStreamPlayer
var explosion_player: AudioStreamPlayer
var flamethrower_player: AudioStreamPlayer2D

var sfx_players: Array[AudioStreamPlayer2D] = []
var max_sfx_players: int = 20
var current_sfx_index: int = 0

var shoot_sound: AudioStream
var flamethrower_sound: AudioStream
var upgrade_sound: AudioStream
var button_click_sound: AudioStream
var close_sound: AudioStream
var place_tower_sound: AudioStream
var damage_sound: AudioStream
var explosion_sound: AudioStream
var background_music_1: AudioStream
var background_music_2: AudioStream

# Volume settings (0.0 to 1.0)
@export var music_volume: float = 0.2
@export var sfx_volume: float = 0.8

var music_muted: bool = false
var sfx_muted: bool = false

# Pitch variation range for shooting sounds
var pitch_variation_range: float = 0.15

func _ready() -> void:
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	_update_music_volume()
	
	# global SFX player for non-positional sounds
	global_sfx_player = AudioStreamPlayer.new()
	add_child(global_sfx_player)
	global_sfx_player.volume_db = linear_to_db(sfx_volume)
	
	# dedicated explosion player so it doesn't get cut off
	explosion_player = AudioStreamPlayer.new()
	add_child(explosion_player)
	explosion_player.volume_db = linear_to_db(sfx_volume)
	
	# dedicated flamethrower player for continuous looping sound
	flamethrower_player = AudioStreamPlayer2D.new()
	add_child(flamethrower_player)
	flamethrower_player.volume_db = linear_to_db(sfx_volume)
	
	# Create SFX player pool
	for i in range(max_sfx_players):
		var player = AudioStreamPlayer2D.new()
		add_child(player)
		sfx_players.append(player)
	_update_sfx_volume()
	
	load_audio_resources()

func load_audio_resources() -> void:
	shoot_sound = load("res://Audio/SFX/720118__baggonotes__player_shoot1.wav")
	flamethrower_sound = load("res://Audio/SFX/flamethrower-sound-effect-4214022.wav")
	upgrade_sound = load("res://Audio/SFX/721514__baggonotes__points_tick2.wav")
	button_click_sound = load("res://Audio/SFX/721503__baggonotes__button_click2.wav")
	close_sound = load("res://Audio/SFX/704259__baggonotes__idcard_caseinsert.wav")
	place_tower_sound = load("res://Audio/SFX/434130__89o__place.wav")
	damage_sound = load("res://Audio/SFX/689664__immergomedia__plasticsnatch01.wav")
	explosion_sound = load("res://Audio/SFX/490253__anomaex__sci-fi_explosion.wav")
	background_music_1 = load("res://Audio/Music/685206__x1shi__video-game-music-seamless.wav")
	background_music_2 = load("res://Audio/Music/735469__seth_makes_sounds__darksummer.wav")

# Play a sound effect at a specific position
func play_sfx(stream: AudioStream, position: Vector2 = Vector2.ZERO, pitch_scale: float = 1.0) -> void:
	if stream == null:
		push_warning("SoundManager: Attempted to play null audio stream")
		return
	
	if sfx_muted:
		return
	
	var player = sfx_players[current_sfx_index]
	player.stream = stream
	player.global_position = position
	player.pitch_scale = pitch_scale
	player.play()
	
	# Round-robin through players
	current_sfx_index = (current_sfx_index + 1) % max_sfx_players


func play_shoot_sound(position: Vector2 = Vector2.ZERO) -> void:
	var random_pitch = 1.0 + randf_range(-pitch_variation_range, pitch_variation_range)
	play_sfx(shoot_sound, position, random_pitch)
	
func play_flamethrower_sound(position: Vector2 = Vector2.ZERO) -> void:
	play_sfx(flamethrower_sound, position, 1.5)

func start_flamethrower_sound(position: Vector2 = Vector2.ZERO) -> void:
	if flamethrower_sound == null:
		push_warning("SoundManager: Attempted to play null flamethrower sound")
		return
	
	if sfx_muted:
		return
	
	# Only start if not already playing
	if flamethrower_player.playing:
		return
	
	flamethrower_player.stream = flamethrower_sound
	flamethrower_player.global_position = position
	flamethrower_player.pitch_scale = 1.5
	flamethrower_player.play()

func stop_flamethrower_sound() -> void:
	if flamethrower_player.playing:
		flamethrower_player.stop()

func play_upgrade_sound(position: Vector2 = Vector2.ZERO) -> void:
	play_sfx(upgrade_sound, position)

func play_button_click_sound(position: Vector2 = Vector2.ZERO) -> void:
	play_sfx(button_click_sound, position)

func play_close_sound(position: Vector2 = Vector2.ZERO) -> void:
	play_sfx(close_sound, position)

func play_place_tower_sound(position: Vector2 = Vector2.ZERO) -> void:
	play_sfx(place_tower_sound, position)

func play_damage_sound(position: Vector2 = Vector2.ZERO) -> void:
	play_global_sfx(damage_sound)

func play_explosion_sound(position: Vector2 = Vector2.ZERO) -> void:
	if explosion_sound == null:
		push_warning("SoundManager: Attempted to play null explosion sound")
		return
	
	if sfx_muted:
		return
	
	# Use dedicated explosion player so it doesn't get interrupted
	explosion_player.stream = explosion_sound
	explosion_player.play()

func play_global_sfx(stream: AudioStream) -> void:
	if stream == null:
		push_warning("SoundManager: Attempted to play null audio stream")
		return
	
	if sfx_muted:
		return
	
	global_sfx_player.stream = stream
	global_sfx_player.play()

func play_music(stream: AudioStream, fade_in: bool = false) -> void:
	if stream == null:
		push_warning("SoundManager: Attempted to play null music stream")
		return
	
	if music_player.stream == stream and music_player.playing:
		return
	
	music_player.stream = stream
	_update_music_volume()
	music_player.play()
	
	if fade_in:
		music_player.volume_db = -80.0
		var tween = create_tween()
		tween.tween_property(music_player, "volume_db", _get_music_volume_db(), 1.0)

func stop_music(fade_out: bool = false) -> void:
	if fade_out:
		var tween = create_tween()
		tween.tween_property(music_player, "volume_db", -80.0, 1.0)
		tween.tween_callback(music_player.stop)
	else:
		music_player.stop()

func set_music_volume(volume: float) -> void:
	music_volume = clamp(volume, 0.0, 1.0)
	_update_music_volume()

func set_sfx_volume(volume: float) -> void:
	sfx_volume = clamp(volume, 0.0, 1.0)
	_update_sfx_volume()

func toggle_music_mute() -> void:
	music_muted = !music_muted
	_update_music_volume()

func toggle_sfx_mute() -> void:
	sfx_muted = !sfx_muted

func set_music_mute(muted: bool) -> void:
	music_muted = muted
	_update_music_volume()

func set_sfx_mute(muted: bool) -> void:
	sfx_muted = muted

func get_music_volume() -> float:
	return music_volume

func get_sfx_volume() -> float:
	return sfx_volume

func is_music_muted() -> bool:
	return music_muted

func is_sfx_muted() -> bool:
	return sfx_muted

func _update_music_volume() -> void:
	if music_muted:
		music_player.volume_db = -80.0
	else:
		music_player.volume_db = _get_music_volume_db()

func _get_music_volume_db() -> float:
	return linear_to_db(music_volume)

func _update_sfx_volume() -> void:
	var volume_db = linear_to_db(sfx_volume) if not sfx_muted else -80.0
	global_sfx_player.volume_db = volume_db
	explosion_player.volume_db = volume_db
	if flamethrower_player:
		flamethrower_player.volume_db = volume_db
	for player in sfx_players:
		player.volume_db = volume_db
