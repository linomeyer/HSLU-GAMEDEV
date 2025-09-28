extends CanvasLayer

signal start_game

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()


func show_game_over():
	show_message("Game Over")
	await $MessageTimer.timeout

	$Message.text = "Evade the enemies!\nUse WASD to move and SPACE to dash"
	$Message.show()
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()

	
func update_score(score):
	$ScoreLabel.text = str(score)
	
func update_hp(hp: int) -> void:
	$HPLabel.text = "HP: " + str(hp)

func _on_message_timer_timeout() -> void:
	$Message.hide()


func _on_start_button_pressed() -> void:
	$StartButton.hide()
	start_game.emit()
