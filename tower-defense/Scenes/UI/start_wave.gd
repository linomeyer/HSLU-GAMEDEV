extends Button


func _on_pressed() -> void:
	SoundManager.play_button_click_sound(global_position)
	if Game.wave < 8:
		Game.startWave()
	elif Game.wave == 8:
		Game.startWave()
		$".".disabled = true
