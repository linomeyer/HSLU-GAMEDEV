extends Node2D

@onready var enemy = preload("res://Scenes/Enemies/soldier_a.tscn")


func _on_spawn_timer_timeout() -> void:
	$Path2D.add_child(enemy.instantiate())
	
