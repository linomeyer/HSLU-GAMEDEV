extends Node

var damageLevel = 0
var attackSpeedLevel = 0
var rangeLevel = 0

func _on_damage_pressed() -> void:
	damageLevel += 1
	SignalBus.towerUpgraded.emit(Enums.UpgradeType.DAMAGE, self.get_parent().name, damageLevel)


func _on_attack_speed_pressed() -> void:
	attackSpeedLevel += 1
	SignalBus.towerUpgraded.emit(Enums.UpgradeType.ATTACK_SPEED, self.get_parent().name, attackSpeedLevel)


func _on_range_pressed() -> void:
	rangeLevel += 1
	SignalBus.towerUpgraded.emit(Enums.UpgradeType.RANGE, self.get_parent().name, rangeLevel)
