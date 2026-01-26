extends Node

@export var gold = 75
@export var health = 10

var wave = 0
var game_time = 0

func decreaseHealthBy(number: int) -> void:
	health -= number
	# Play damage sound
	SoundManager.play_damage_sound()
	SignalBus.playerLostHealth.emit()
	
func increaseGoldBy(number: int) -> void:
	gold += number
	SignalBus.goldChanged.emit()
	
func decreaseGoldBy(number: int) -> void:
	gold -= number
	SignalBus.goldChanged.emit()
	
func reset() -> void:
	gold = 75
	health = 10
	game_time = 0
	wave = 0
	
	SignalBus.goldChanged.emit()
	SignalBus.playerLostHealth.emit()
	SignalBus.timeChanged.emit()

func startWave() -> void:
	SignalBus.startWave.emit(wave)
	wave += 1

func win() -> void:
	SignalBus.gameWon.emit()
