extends Button

func _on_pressed() -> void:
	SoundManager.play_button_click_sound(global_position)
	var options_menu = get_node_or_null("../OptionsMenu")
	if options_menu:
		options_menu.visible = true
