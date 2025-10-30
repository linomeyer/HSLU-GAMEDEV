extends Area2D
class_name Detector

signal belt_detected

var detecting = false

func detect():
	detecting = true
	
func _physics_process(delta: float) -> void:
	if not detecting:
		return
	var areas = get_overlapping_areas()
	for area in areas:
		if area.is_in_group("belt") and area.can_receive_item():
			belt_detected.emit(area)
			detecting = false
			break
