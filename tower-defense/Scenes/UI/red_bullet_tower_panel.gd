extends Panel

@onready var tower: PackedScene = preload("res://Scenes/Towers/red_bullet_tower.tscn")

func _on_gui_input(event: InputEvent) -> void:
	var towerInstance: StaticBody2D = tower.instantiate()
	if event is InputEventMouseButton and event.button_mask == 1: # pressing
		add_child(towerInstance)
		towerInstance.process_mode = Node.PROCESS_MODE_DISABLED
		towerInstance.global_position = get_global_mouse_position()
		pass
	elif event is InputEventMouseMotion and event.button_mask == 1: # dragging
		# get child 1 because 0 is the sprite
		get_child(1).global_position = get_global_mouse_position()
		pass
	elif event is InputEventMouseButton and event.button_mask == 0: # dropping
		if get_viewport().gui_get_hovered_control() == null: # only place if not on ui
			towerInstance.global_position = get_global_mouse_position()
			towerInstance.get_node("RangeDisplay").hide()
			SignalBus.towerPlaced.emit(towerInstance)
			get_child(1).queue_free()
	
