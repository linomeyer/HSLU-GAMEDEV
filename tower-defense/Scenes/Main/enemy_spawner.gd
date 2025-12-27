extends Node2D

@onready var enemy = preload("res://Scenes/Enemies/soldier_a.tscn")


func _on_spawn_timer_timeout() -> void:
	var newFollowPath = PathFollow2D.new()
	newFollowPath.loop = true
	newFollowPath.add_child(enemy.instantiate())
	$Path2D.add_child(newFollowPath)
	newFollowPath.set_progress_ratio(0)
	
	
