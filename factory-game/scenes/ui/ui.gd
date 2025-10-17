extends CanvasLayer

@onready var assembler_button = $AssemblerButton

var build_controller: Node = null

func _ready():
	assembler_button.pressed.connect(_on_assembler_button_pressed)

func _on_assembler_button_pressed():
	if build_controller:
		build_controller.start_building("assembler1")
