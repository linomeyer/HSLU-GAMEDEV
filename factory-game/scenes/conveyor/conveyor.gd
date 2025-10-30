extends Area2D
class_name Conveyor

enum Direction { LEFT, RIGHT, UP, DOWN }

@onready var item_holder = $ItemHolder
@onready var detector = $Detector
@onready var sprite = $Sprite2D

@export var to_direction: Direction = Direction.LEFT
@export var from_direction: Direction = Direction.RIGHT

func _ready() -> void:
	set_direction()
	
func can_receive_item():
	return item_holder.get_child_count() == 0
	
func receive_item(item:Node2D):
	item_holder.receive_item(item)
	
func _on_detector_belt_detected(area: Area2D):
	var item = item_holder.offload_item()
	area.receive_item(item)
	
	
func _on_item_holder_item_held():
	detector.detect()

func set_direction():
	match to_direction:
		Direction.LEFT:
			detector.position = Vector2.LEFT * 16
			match from_direction:
				Direction.RIGHT:
					sprite.frame = 1
				Direction.UP:
					sprite.frame = 9
				Direction.DOWN:
					sprite.frame = 2
		Direction.RIGHT:
			detector.position = Vector2.RIGHT * 16
			match from_direction:
				Direction.LEFT:
					sprite.frame = 11
				Direction.UP:
					sprite.frame = 10
				Direction.DOWN:
					sprite.frame = 3
		Direction.UP:
			detector.position = Vector2.UP * 16
			match from_direction:
				Direction.LEFT:
					sprite.frame = 12
				Direction.DOWN:
					sprite.frame = 7
				Direction.RIGHT:
					sprite.frame = 8
		Direction.DOWN:
			detector.position = Vector2.DOWN * 16
			match from_direction:
				Direction.LEFT:
					sprite.frame = 4
				Direction.UP:
					sprite.frame = 5
				Direction.RIGHT:
					sprite.frame = 0
