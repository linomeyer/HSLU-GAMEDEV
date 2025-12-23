extends StaticBody2D

var bullet: PackedScene = preload("res://Scenes/Towers/Bullets/red_bullet.tscn")
var currentTargets = []
var currentTarget: PathFollow2D

func _process(_delta: float) -> void:
	if is_instance_valid(currentTarget):
		look_at(currentTarget.global_position)


func _on_tower_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		select_target()
		if $ShotTimer.is_stopped():
			$ShotTimer.timeout.emit()
			$ShotTimer.start()


func _on_tower_body_exited(body: Node2D) -> void:
	currentTarget = null
	if body.is_in_group("Enemy"):
		select_target()


func select_target() -> void:
	var targets = []
	var nodesInRange = $Tower.get_overlapping_bodies()
	
	if nodesInRange.size() == 0:
		$ShotTimer.stop()
		pass
	

	for node in nodesInRange:
		if node.is_in_group("Enemy"):
			targets.append(node)
			
			var enemyPath: PathFollow2D = node.get_parent()
			if currentTarget == null:
				currentTarget = enemyPath
			else:
				if enemyPath.get_progress() > currentTarget.get_progress():
					currentTarget = enemyPath
	currentTargets = targets
	

func _on_shot_timer_timeout() -> void:
	select_target()
	if currentTarget != null:
		var bulletInstance: CharacterBody2D = bullet.instantiate()
		bulletInstance.target = currentTarget.get_child(0) # get CharacterBody position from PathFollow
		$BulletContainer.add_child(bulletInstance)
		bulletInstance.global_position = $Aim.global_position
