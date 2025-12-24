extends Node2D

func _ready() -> void:
	SignalBus.towerPlaced.connect(_on_tower_placed)
	
	
func _on_tower_placed(tower: StaticBody2D) -> void:
	$Towers.add_child(tower)
