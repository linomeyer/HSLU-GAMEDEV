extends Node2D

@export var speed = 25
@export var moving_item = false

signal item_held

func _physics_process(delta):
	if not moving_item or get_child_count() == 0:
		return
	var item = get_child(0)
	if item is Node2D:
		item.global_position = item.global_position.move_toward(get_parent().global_position, speed * delta)
		if item.global_position == get_parent().global_position:
			hold_item()
			

func hold_item():
	moving_item = false
	item_held.emit()


func receive_item(item: Node2D):
	item.reparent(self, true)
	moving_item = true


func offload_item():
	var item = get_child(0)
	return item
