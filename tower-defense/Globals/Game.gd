extends Node

@export var gold = 100
@export var health = 10

var game_time = 0

func decreaseHealthBy(number: int) -> void:
	health -= number
	SignalBus.playerLostHealth.emit()
	
func increaseGoldBy(number: int) -> void:
	gold += number
	SignalBus.goldChanged.emit()
	
func decreaseGoldBy(number: int) -> void:
	gold -= number
	SignalBus.goldChanged.emit()
	
func reset() -> void:
	gold = 100
	health = 10
	game_time = 0
	
	SignalBus.goldChanged.emit()
	SignalBus.playerLostHealth.emit()
	SignalBus.timeChanged.emit()
