extends Panel

@onready var tower: PackedScene = preload("res://Scenes/Towers/red_bullet_tower.tscn")

func _on_gui_input(event: InputEvent) -> void:
	var towerInstance: StaticBody2D = tower.instantiate()
	if event is InputEventMouseButton and event.button_mask == 1: # pressing
		$TowerInstance.add_child(towerInstance)
		towerInstance.process_mode = Node.PROCESS_MODE_DISABLED
		towerInstance.global_position = get_global_mouse_position()
	elif event is InputEventMouseMotion and event.button_mask == 1: # dragging
		# get child 2 because 0 is the sprite and 1 the label
		$TowerInstance.get_child(0).global_position = get_global_mouse_position()
		check_placeable()
			
	elif event is InputEventMouseButton and event.button_mask == 0: # dropping
		if check_placeable():
			towerInstance.global_position = get_global_mouse_position()
			SignalBus.towerPlaced.emit(towerInstance)
			$TowerInstance.get_child(0).get_node("RangeDisplay2").hide()
			$TowerInstance.get_child(0).queue_free()
		else:
			$TowerInstance.get_child(0).get_node("RangeDisplay2").hide()
			$TowerInstance.get_child(0).queue_free()
	
# is placeable if not on UI and on a grass tile and no other tower placed
func check_placeable() -> bool:
		var tilemap: TileMapLayer = get_tree().get_root().get_node("Main/TileMap")
		var tileLocation = tilemap.local_to_map(get_global_mouse_position())
		var currentTile = tilemap.get_cell_atlas_coords(tileLocation)
		var rangeDisplay = $TowerInstance.get_child(0).get_node("RangeDisplay2")
		rangeDisplay.show()
		
		if currentTile == Vector2i(4, 5) && get_viewport().gui_get_hovered_control() == null && $TowerInstance.get_child(0).get_node("TowerDetector").get_overlapping_bodies().size() < 1:
			if rangeDisplay.color != Color("2e2e305a"):
				rangeDisplay.color  = Color("2e2e305a")
				rangeDisplay.queue_redraw()
			return true
		else:
			if rangeDisplay.color != Color(255,0,0, 0.3):
				rangeDisplay.color = Color(255,0,0, 0.3)
				rangeDisplay.queue_redraw()
			return false
	
