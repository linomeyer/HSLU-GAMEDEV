extends CharacterBody2D

var target: CharacterBody2D
@export var bullet_damage = 0
@export var speed = 600


func _physics_process(_delta: float) -> void:
	if is_instance_valid(target):
		var targetPos = target.global_position
		velocity = global_position.direction_to(targetPos) * speed
		look_at(targetPos)
		move_and_slide()
	else:
		queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		print(bullet_damage)
		body.health -= bullet_damage
		queue_free()
