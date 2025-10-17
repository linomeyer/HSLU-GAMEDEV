extends Node2D

@export var buildings: Dictionary = {
	"assembler1": preload("res://scenes/buildings/assembler_1.tscn"),
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

func start_building(building_name: String):
	if preview_instance:
		preview_instance.queue_free()
	current_building_scene = buildings[building_name]
	preview_instance = current_building_scene.instantiate()
	add_child(preview_instance)
	preview_instance.modulate = Color(1, 1, 1, 0.5)

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if preview_instance and can_place:
			place_building()

func check_placement_validity():
	# Simplified validity check (no overlap logic yet)
	can_place = true
	preview_instance.modulate = Color(0, 1, 0, 0.5) if can_place else Color(1, 0, 0, 0.5)


func place_building():
	var new_building = current_building_scene.instantiate()
	new_building.global_position = preview_instance.global_position
	get_parent().get_node("BuildingsRoot").add_child(new_building)
