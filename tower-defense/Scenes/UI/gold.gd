extends Label


func _ready() -> void:
	SignalBus.goldChanged.connect(_setText)
	self.text = "Gold: " + str(Game.gold)

func _setText() -> void:
	self.text = "Gold: " + str(Game.gold)
