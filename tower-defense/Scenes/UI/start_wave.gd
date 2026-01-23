extends Button


func _on_pressed() -> void:
	SoundManager.play_button_click_sound(global_position)
	Game.startWave()
