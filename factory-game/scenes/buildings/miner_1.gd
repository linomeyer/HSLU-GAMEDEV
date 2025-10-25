extends Area2D

@onready var miner = $Sprite2D
var item_buffer = 0
var item_type = Constants.ResourceType.IRON

func _on_collection_timer_timeout() -> void:
	if(item_buffer < 100):
		item_buffer += 1


func _on_belt_detection_zone_area_entered(area: Area2D) -> void:
	if area.is_in_group("belt") and area.get_parent().name == "BuildingsRoot":
		print("emit")
		SignalBus.belt_attached.emit(item_type)
