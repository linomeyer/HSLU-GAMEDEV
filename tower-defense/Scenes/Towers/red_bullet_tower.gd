extends StaticBody2D

var bullet: PackedScene = preload("res://Scenes/Towers/Bullets/red_bullet.tscn")
var currentTargets = []
var currentTarget: PathFollow2D

@export var base_range: float = 256
@export var base_damage: float = 5
@export var base_attack_speed: float = 0.5

var range: float = base_range
var damage: float = base_damage
var attack_speed: float = base_attack_speed

func _ready() -> void:
	SignalBus.towerUpgraded.connect(_tower_upgraded)
	$RangeDisplay2.global_transform = $Tower/Range.global_transform
	$Upgrade/UpgradePanel/HBoxContainer/Damage.text = str(damage)
	$Upgrade/UpgradePanel/HBoxContainer/AttackSpeed.text = str(attack_speed)
	$Upgrade/UpgradePanel/HBoxContainer/Range.text = str(range)

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
	if body.is_in_group("Enemy"):
		currentTarget = null
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
		var bulletInstance1: CharacterBody2D = bullet.instantiate()
		var bulletInstance2: CharacterBody2D = bullet.instantiate()
		
		# get CharacterBody position from PathFollow
		bulletInstance1.target = currentTarget.get_child(0)
		bulletInstance2.target = currentTarget.get_child(0)
		
		bulletInstance1.bullet_damage = damage
		bulletInstance2.bullet_damage = damage
		
		bulletInstance1.global_position = $Aim.global_position
		bulletInstance2.global_position = $Aim2.global_position
		
		$BulletContainer.add_child(bulletInstance1)
		$BulletContainer.add_child(bulletInstance2)


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_mask == 1:
		SignalBus.hideOtherUpgradePanels.emit(self.name)
		var upgradePanel = $Upgrade/UpgradePanel
		upgradePanel.visible = !upgradePanel.visible
		$RangeDisplay2.visible = !$RangeDisplay2.visible
		upgradePanel.global_position = self.position + Vector2(-250, 100)
		

func _tower_upgraded(upgradeType: Enums.UpgradeType, towerName: String, upgradeLevel: int):
	if towerName == self.name:
		if upgradeType == Enums.UpgradeType.DAMAGE:
			damage = base_damage + (2.5 * upgradeLevel)
			$Upgrade/UpgradePanel/HBoxContainer/Damage.text = str(damage)
		elif upgradeType == Enums.UpgradeType.ATTACK_SPEED:
			attack_speed = base_attack_speed + (0.25 * upgradeLevel)
			$ShotTimer.wait_time = 1 / attack_speed
			$Upgrade/UpgradePanel/HBoxContainer/AttackSpeed.text = str(attack_speed)
			
		elif upgradeType == Enums.UpgradeType.RANGE:
			range = base_range + (64 * upgradeLevel)
			$Tower/Range.shape.radius = range
			$RangeDisplay2.queue_redraw()
			$Upgrade/UpgradePanel/HBoxContainer/Range.text = str(range)
