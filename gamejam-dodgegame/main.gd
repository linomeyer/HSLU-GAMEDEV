extends Node

@export var enemy_scene: PackedScene
var score

func _ready():
	pass

func new_game():
	score = 0
	$Player.hp = $Player.maxhp
	# remove all enemies from previous game
	get_tree().call_group("enemies", "queue_free")
	
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	$HUD.update_hp($Player.hp)
	
	$Player.start($StartPosition.position)
	$StartTimer.start()
	


func _on_enemy_timer_timeout() -> void:
	var enemy = enemy_scene.instantiate()

	#random spawn at edge of screen
	var enemy_spawn_location = $EnemyPath/EnemySpawnLocation
	enemy_spawn_location.progress_ratio = randf()

	enemy.position = enemy_spawn_location.position

	var direction = enemy_spawn_location.rotation + PI / 2
	# Add some randomness to the direction
	direction += randf_range(-PI / 4, PI / 4)
	enemy.rotation = direction

	#velocity with randomness
	var velocity = Vector2(randf_range(600.0, 1000.0), 0.0)
	enemy.linear_velocity = velocity.rotated(direction)

	add_child(enemy)


func _on_score_timer_timeout() -> void:
	score += 10
	$HUD.update_score(score)


func _on_start_timer_timeout() -> void:
	$EnemyTimer.start()
	$ScoreTimer.start()


func _on_player_hit() -> void:
	$Player.hp -= 1
	$HUD.update_hp($Player.hp)
	if($Player.hp > 0):
		print_debug("player hit: ", $Player.hp)
	else:
		$HUD.show_game_over()
		$Player.emit_signal("death")
		$EnemyTimer.stop()
		$ScoreTimer.stop()
