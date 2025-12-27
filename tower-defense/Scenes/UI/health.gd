extends Label


func _ready() -> void:
	SignalBus.playerLostHealth.connect(_setText)
	self.text = "Health: " + str(Game.health)

func _setText() -> void:
	print("connect playerLostHealth")
	print(Game.health)
	self.text = "Health: " + str(Game.health)
