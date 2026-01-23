extends Node

@export var damageLevelUpgradeCost = 0
@export var attackSpeedLevelUpgradeCost = 0
@export var rangeLevelUpgradeCost = 0

var damageLevel = 0
var attackSpeedLevel = 0
var rangeLevel = 0

func _ready() -> void:
	$UpgradePanel/HBoxContainer/AttackSpeed/Cost.text = str(damageLevelUpgradeCost)
	$UpgradePanel/HBoxContainer/Damage/Cost.text = str(attackSpeedLevelUpgradeCost)
	$UpgradePanel/HBoxContainer/Range/Cost.text = str(rangeLevelUpgradeCost)

func _on_damage_pressed() -> void:
	if damageLevel < 3 && Game.gold >= damageLevelUpgradeCost:
		Game.decreaseGoldBy(damageLevelUpgradeCost)
		damageLevel += 1
		$UpgradePanel/HBoxContainer/Damage/ProgressBar.value = damageLevel
		SignalBus.towerUpgraded.emit(Enums.UpgradeType.DAMAGE, self.get_parent().name, damageLevel)
	if damageLevel >= 3:
		$UpgradePanel/HBoxContainer/Damage.disabled = true

func _on_attack_speed_pressed() -> void:
	if attackSpeedLevel < 3 && Game.gold >= attackSpeedLevelUpgradeCost:
		Game.decreaseGoldBy(attackSpeedLevelUpgradeCost)
		attackSpeedLevel += 1
		$UpgradePanel/HBoxContainer/AttackSpeed/ProgressBar.value = attackSpeedLevel
		SignalBus.towerUpgraded.emit(Enums.UpgradeType.ATTACK_SPEED, self.get_parent().name, attackSpeedLevel)
	if attackSpeedLevel >= 3:
		$UpgradePanel/HBoxContainer/AttackSpeed.disabled = true

func _on_range_pressed() -> void:
	if rangeLevel < 3 && Game.gold >= rangeLevelUpgradeCost:
		Game.decreaseGoldBy(rangeLevelUpgradeCost)
		rangeLevel += 1
		$UpgradePanel/HBoxContainer/Range/ProgressBar.value = rangeLevel
		SignalBus.towerUpgraded.emit(Enums.UpgradeType.RANGE, self.get_parent().name, rangeLevel)
	if rangeLevel >= 3:
		$UpgradePanel/HBoxContainer/Range.disabled = true
