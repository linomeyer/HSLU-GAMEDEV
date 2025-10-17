extends CharacterBody2D

@export var speed : float = 100
@export var starting_direction : Vector2 = Vector2(0, 1)

@onready var animation_tree = $AnimationTree
@onready var walk_state_machine = animation_tree.get("parameters/playback")

func _ready() -> void:
	animation_tree.set("parameters/walk/blend_position", starting_direction)

func _physics_process(_delta: float) -> void:
	var input_direction = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)
	update_walk_animation(input_direction)

	velocity = input_direction.normalized() * speed
	move_and_slide()

func update_walk_animation(input_direction : Vector2):
	if(input_direction != Vector2.ZERO):
		animation_tree.set("parameters/Walk/blend_position", input_direction)
		walk_state_machine.travel("Walk")
	else:
		walk_state_machine.travel("Idle")
