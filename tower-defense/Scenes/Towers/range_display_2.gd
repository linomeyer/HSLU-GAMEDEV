extends Node2D

@onready var range := $"../Tower/Range"

var color = Color("2e2e305a")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_transform = range.global_transform

func _draw() -> void:
	var shape: CircleShape2D = range.shape
	draw_circle(Vector2.ZERO, shape.radius, color)
