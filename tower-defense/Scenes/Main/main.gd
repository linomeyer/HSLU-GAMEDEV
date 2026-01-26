extends Node2D


func _ready() -> void:
	Game.reset()
	
	SignalBus.towerPlaced.connect(_on_tower_placed)
	SignalBus.hideOtherUpgradePanels.connect(_hide_upgrade_panels)
	SignalBus.playerLostHealth.connect(_on_player_lost_health)
	SignalBus.restart.connect(_on_restart)
	SignalBus.gameWon.connect(_on_game_won)
	
	# Start background music
	SoundManager.play_music(SoundManager.background_music_1)
	
func _on_tower_placed(tower: StaticBody2D) -> void:
	$Towers.add_child(tower)
	
func _hide_upgrade_panels(currentTowerName: String) -> void:
	for tower in $Towers.get_children():
		if tower.name != currentTowerName:
			tower.get_node("Upgrade/UpgradePanel").hide()
			tower.get_node("RangeDisplay2").hide()

func _on_player_lost_health() -> void:
	if Game.health <= 0:
		# Play explosion sound only once when health first reaches zero
		if not $GameOver.visible:
			SoundManager.play_explosion_sound()
			SoundManager.stop_flamethrower_sound()
			$GameOver.visible = true
			
			# Play DeathExplosion animation from tank tower
			if has_node("TankTower/DeathExplosion"):
				$TankTower/DeathExplosion.emitting = true
		
func _on_restart() -> void:
	SoundManager.stop_flamethrower_sound()
	get_tree().change_scene_to_file("res://Scenes/UI/main_menu.tscn")
		
func _on_game_won() -> void:
	if not $GameWin.visible:
		SoundManager.stop_flamethrower_sound()
		$GameWin.visible = true
	
