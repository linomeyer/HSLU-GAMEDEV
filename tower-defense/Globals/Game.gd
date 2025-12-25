extends Node

@export var gold = 100
@export var health = 10


func decreaseHealthBy(number: int) -> void:
	health -= number
	SignalBus.playerLostHealth.emit()
	
func increaseGoldBy(number: int) -> void:
	gold += number
	SignalBus.goldChanged.emit()
