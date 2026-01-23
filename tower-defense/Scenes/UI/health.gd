extends Label


func _ready() -> void:
	SignalBus.playerLostHealth.connect(_setText)
	self.text = "Health: " + str(Game.health)

func _setText() -> void:
	self.text = "Health: " + str(Game.health)
