extends Node2D

func _ready() -> void:
	SignalBus.towerPlaced.connect(_on_tower_placed)
	SignalBus.hideOtherUpgradePanels.connect(_hide_upgrade_panels)
	
	
func _on_tower_placed(tower: StaticBody2D) -> void:
	$Towers.add_child(tower)
	
func _hide_upgrade_panels(currentTowerName: String) -> void:
	for tower in $Towers.get_children():
		if tower.name != currentTowerName:
			tower.get_node("Upgrade/UpgradePanel").hide()
