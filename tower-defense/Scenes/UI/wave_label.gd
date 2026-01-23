extends Label

func _ready() -> void:
	SignalBus.startWave.connect(_setText)
	self.text = "Wave: " + str(Game.wave + 1)

func _setText(wave_number: int) -> void:
	self.text = "Wave: " + str(Game.wave + 1)
