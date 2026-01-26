extends Node

signal towerPlaced(tower: StaticBody2D)

signal hideOtherUpgradePanels(currentTowerName: String)

signal towerUpgraded(upgradeType: Enums.UpgradeType, towerName: String, upgradeLevel: int)  

signal playerLostHealth()
signal goldChanged()
signal timeChanged()

signal restart()
signal gameWon()

signal startWave(waveNumber: int)

signal flameThrowerDamage(damage: float, target: PathFollow2D)
