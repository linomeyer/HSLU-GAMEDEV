extends Area2D


func _ready() -> void:
	SignalBus.belt_attached.connect(_on_belt_connected_to_node)


func _on_belt_connected_to_node(item_type: Constants.ResourceType):
	print("test")
