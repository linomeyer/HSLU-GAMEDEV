extends Node2D

@onready var box_path = load("res://scenes/conveyor/box.tscn")
@onready var detector = $Detector
@onready var timer = $Timer
@onready var hold = $Hold

func _on_detector_belt_detected(destination: Node2D):
	var item = box_path.instantiate()
	hold.add_child(item)
	destination.receive_item(item)
	timer.start()

func _on_timer_timeout():
	detector.detect()
