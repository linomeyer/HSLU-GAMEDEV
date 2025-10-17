extends Node2D

@onready var build_controller = $BuildController
@onready var ui = $UI

func _ready():
	ui.build_controller = build_controller
