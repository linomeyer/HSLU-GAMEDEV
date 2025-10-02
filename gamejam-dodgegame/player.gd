extends Area2D

signal hit
signal death
signal has_dashed

@export var hp = 3
@export var maxhp = 3

@export var speed = 800
@export var dash_speed = 2000
@export var dash_duration = 0.3
@export var dash_on_cd = false

var screen_size
var velocity: Vector2 = Vector2.ZERO
var last_direction: Vector2 = Vector2.RIGHT

var is_dashing: bool = false
var dash_timer: float = 0.0


func _ready():
	hide()
	screen_size = get_viewport_rect().size


func start(pos):
	position = pos
	show()
	$Sprite2D.show()
	$CollisionShape2D.disabled = false



func _process(delta: float) -> void:
	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0.0:
			is_dashing = false
			$CollisionShape2D.disabled = false
	else:
		velocity = Vector2.ZERO
		if Input.is_action_pressed("move_right"):
			velocity.x += 1
		if Input.is_action_pressed("move_left"):
			velocity.x -= 1
		if Input.is_action_pressed("move_down"):
			velocity.y += 1
		if Input.is_action_pressed("move_up"):
			velocity.y -= 1

		if velocity != Vector2.ZERO:
			last_direction = velocity.normalized()

		velocity = velocity.normalized() * speed

	if Input.is_action_just_pressed("dash") and not is_dashing and last_direction != Vector2.ZERO and !dash_on_cd:
		is_dashing = true
		dash_timer = dash_duration
		$CollisionShape2D.disabled = true
		velocity = last_direction * dash_speed
		has_dashed.emit()

	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)


func _on_body_entered(body: Node2D) -> void:
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)
	$HitTimer.start()
	$HitFlashAnimationPlayer.play("hitFlash")


func _on_hit_timer_timeout() -> void:
	$CollisionShape2D.set_deferred("disabled", false)


func _on_death() -> void:
	$Sprite2D.hide()
	$DeathExplosion.emitting = true
