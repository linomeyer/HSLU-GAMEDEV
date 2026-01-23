extends Control

@onready var music_slider: HSlider = $Panel/VBoxContainer/MusicContainer/MusicSlider
@onready var sfx_slider: HSlider = $Panel/VBoxContainer/SFXContainer/SFXSlider
@onready var music_mute_button: CheckBox = $Panel/VBoxContainer/MusicContainer/MusicMute
@onready var sfx_mute_button: CheckBox = $Panel/VBoxContainer/SFXContainer/SFXMute

func _ready() -> void:
	music_slider.value = SoundManager.get_music_volume()
	sfx_slider.value = SoundManager.get_sfx_volume()
	music_mute_button.button_pressed = SoundManager.is_music_muted()
	sfx_mute_button.button_pressed = SoundManager.is_sfx_muted()
	
	# signals
	music_slider.value_changed.connect(_on_music_volume_changed)
	sfx_slider.value_changed.connect(_on_sfx_volume_changed)
	music_mute_button.toggled.connect(_on_music_mute_toggled)
	sfx_mute_button.toggled.connect(_on_sfx_mute_toggled)

func _on_music_volume_changed(value: float) -> void:
	SoundManager.set_music_volume(value)

func _on_sfx_volume_changed(value: float) -> void:
	SoundManager.set_sfx_volume(value)
	# Play a test sound when adjusting
	if not SoundManager.is_sfx_muted():
		SoundManager.play_button_click_sound(global_position)

func _on_music_mute_toggled(button_pressed: bool) -> void:
	SoundManager.set_music_mute(button_pressed)

func _on_sfx_mute_toggled(button_pressed: bool) -> void:
	SoundManager.set_sfx_mute(button_pressed)
	# Play a test sound when unmuting
	if not button_pressed:
		SoundManager.play_button_click_sound(global_position)

func _on_close_pressed() -> void:
	SoundManager.play_close_sound(global_position)
	visible = false
