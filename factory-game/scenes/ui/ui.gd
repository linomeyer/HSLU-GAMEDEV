extends CanvasLayer

@onready var assembler_button = $AssemblerButton
@onready var hotbar = $Hotbar

var selected = -1


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("1"):
		hotbar.start_building(1)
