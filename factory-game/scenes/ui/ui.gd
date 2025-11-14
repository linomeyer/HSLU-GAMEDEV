extends CanvasLayer

@onready var hotbar = $Hotbar
@onready var build_controller = load("res://scripts/buildController.gd")

var selected = -1

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("one"):
		build_controller.start_building(1)
	if Input.is_action_just_pressed("two"):
		build_controller.start_building(2)
	if Input.is_action_just_pressed("three"):
		build_controller.start_building(3)
	if Input.is_action_just_pressed("four"):
		build_controller.start_building(4)
	if Input.is_action_just_pressed("five"):
		build_controller.start_building(5)
	if Input.is_action_just_pressed("six"):
		build_controller.start_building(6)
	if Input.is_action_just_pressed("seven"):
		build_controller.start_building(7)
	if Input.is_action_just_pressed("eight"):
		build_controller.start_building(8)
	if Input.is_action_just_pressed("nine"):
		build_controller.start_building(9)
	if Input.is_action_just_pressed("zero"):
		build_controller.start_building(0)
		
