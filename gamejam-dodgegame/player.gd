extends Area2D

signal hit

@export var speed = 400

var screen_size

func _ready():
	hide()
	screen_size = get_viewport_rect().size


func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

	
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO 
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
		
	velocity = velocity.normalized() * speed
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	


func _on_body_entered(body: Node2D) -> void:
	hide() 
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)
