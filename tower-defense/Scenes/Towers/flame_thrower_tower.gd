extends StaticBody2D

var bullet: PackedScene = preload("res://Scenes/Towers/Bullets/tank_bullet.tscn")
var currentTargets = []
var currentTarget: PathFollow2D

@export var base_range: float = 256
@export var base_damage: float = 15.0
@export var base_attack_speed: float = 1.3

@export var damage_level_increase: float = 5
@export var attack_speed_level_increase: float = 0.3
@export var range_level_increase: float = 96

var range: float
var damage: float
var attack_speed: float # in attacks per second

func _ready() -> void:
	range = base_range
	damage = base_damage
	attack_speed = base_attack_speed
	SignalBus.towerUpgraded.connect(_tower_upgraded)
	$RangeDisplay2.global_transform = $Tower/Range.global_transform
	
	set_upgrade_ui_labels()
	
	# set initial range and attack speed
	$Tower/Range.shape.radius = range
	$RangeDisplay2.queue_redraw()
	$ShotTimer.wait_time = 1 / attack_speed

func _process(_delta: float) -> void:
	if is_instance_valid(currentTarget):
		look_at(currentTarget.global_position)
	
	# Update flamethrower sound position while playing
	if $Aim/Flames.visible and SoundManager.flamethrower_player.playing:
		SoundManager.flamethrower_player.global_position = $Aim.global_position


func _on_tower_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		select_target()
		if $ShotTimer.is_stopped():
			$ShotTimer.timeout.emit()
			$ShotTimer.start()
			$Aim/Flames.visible = true
			SoundManager.start_flamethrower_sound($Aim.global_position)


func _on_tower_body_exited(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		currentTarget = null
		select_target()


func select_target() -> void:
	var targets = []
	var nodesInRange = $Tower.get_overlapping_bodies()
	
	if nodesInRange.size() == 0:
		$ShotTimer.stop()
		$Aim/Flames.visible = false
		SoundManager.stop_flamethrower_sound()
		return
	
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
		SignalBus.flameThrowerDamage.emit(damage, currentTarget)
	elif not $ShotTimer.paused:
		$ShotTimer.stop()
		$Aim/Flames.visible = false
		SoundManager.stop_flamethrower_sound()

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
				damage = base_damage + (damage_level_increase * upgradeLevel)
				
		elif upgradeType == Enums.UpgradeType.ATTACK_SPEED:
			attack_speed = base_attack_speed + (attack_speed_level_increase * upgradeLevel)
			$ShotTimer.wait_time = 1 / attack_speed
		elif upgradeType == Enums.UpgradeType.RANGE:
			range = base_range + (range_level_increase * upgradeLevel)
			$Tower/Range.shape.radius = range
			$Aim/Flames.apply_scale(Vector2(1 + 0.35 * upgradeLevel, 1.2))
			$RangeDisplay2.queue_redraw()
		
		set_upgrade_ui_labels()

func set_upgrade_ui_labels() -> void:
	$Upgrade/UpgradePanel/HBoxContainer/Damage/DamageLabel.text = str(damage)
	$Upgrade/UpgradePanel/HBoxContainer/AttackSpeed/AttackSpeedLabel.text = str(attack_speed)
	$Upgrade/UpgradePanel/HBoxContainer/Range/RangeLabel.text = str(range)
	
