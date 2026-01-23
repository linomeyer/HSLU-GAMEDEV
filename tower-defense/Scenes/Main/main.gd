extends Node2D


func _ready() -> void:
	Game.reset()
	
	SignalBus.towerPlaced.connect(_on_tower_placed)
	SignalBus.hideOtherUpgradePanels.connect(_hide_upgrade_panels)
	SignalBus.playerLostHealth.connect(_on_player_lost_health)
	SignalBus.restart.connect(_on_restart)
	
func _on_tower_placed(tower: StaticBody2D) -> void:
	$Towers.add_child(tower)
	
func _hide_upgrade_panels(currentTowerName: String) -> void:
	for tower in $Towers.get_children():
		if tower.name != currentTowerName:
			tower.get_node("Upgrade/UpgradePanel").hide()
			tower.get_node("RangeDisplay2").hide()

func _on_player_lost_health() -> void:
	if Game.health <= 0:
		$GameOver.visible = true
		
func _on_restart() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/main_menu.tscn")
		
