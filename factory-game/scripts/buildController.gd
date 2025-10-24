extends Node2D

@export var buildings: Dictionary = {
	1: preload("res://scenes/buildings/assembler_1.tscn"),
	2: preload("res://scenes/buildings/conveyor_belt.tscn"),
	3: preload("res://scenes/buildings/electric_pole.tscn"),
	4: preload("res://scenes/buildings/pipe.tscn"),
	5: preload("res://scenes/buildings/robo_arm.tscn"),
	6: preload("res://scenes/buildings/miner_1.tscn"),
	7: preload("res://scenes/buildings/miner_2.tscn"),
	8: preload("res://scenes/buildings/furnace.tscn"),
	9: preload("res://scenes/buildings/water_pump.tscn"),
	0: preload("res://scenes/buildings/boiler.tscn"),
}

const GRID_SIZE = 16
var current_building_scene: PackedScene
var preview_instance: Node2D
var can_place: bool = true

func _process(delta):
	if preview_instance:
		var mouse_pos = get_global_mouse_position()
		var snapped_pos = mouse_pos.snapped(Vector2(GRID_SIZE, GRID_SIZE))
		preview_instance.global_position = snapped_pos
		check_placement_validity()

func start_building(building_index: int):
	if preview_instance:
		preview_instance.queue_free()
	current_building_scene = buildings[building_index]
	preview_instance = current_building_scene.instantiate()
	add_child(preview_instance)
	preview_instance.modulate = Color(1, 1, 1, 0.5)

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if preview_instance and can_place:
			place_building()
	if event is InputEventKey and event.keycode == KEY_ESCAPE and event.pressed and preview_instance:
		preview_instance.queue_free()

func check_placement_validity():
	# Simplified validity check (no overlap logic yet)
	can_place = true
	preview_instance.modulate = Color(0, 1, 0, 0.5) if can_place else Color(1, 0, 0, 0.5)


func place_building():
	var new_building = current_building_scene.instantiate()
	new_building.global_position = preview_instance.global_position
	get_parent().get_node("BuildingsRoot").add_child(new_building)
