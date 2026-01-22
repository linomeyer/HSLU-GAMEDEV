extends CharacterBody2D

@export var speed = 100
@export var health = 20
@export var gold_value = 2
@onready var followPath: PathFollow2D = get_parent()

func _physics_process(delta: float) -> void:
	followPath.set_progress(followPath.get_progress() + speed * delta)
	if followPath.get_progress_ratio() >= 0.99:
		Game.decreaseHealthBy(1)
		followPath.queue_free()
	if health <= 0:
		Game.increaseGoldBy(gold_value)
		followPath.queue_free()
