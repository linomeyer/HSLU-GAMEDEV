extends Node

signal towerPlaced(tower: StaticBody2D)

signal hideOtherUpgradePanels(currentTowerName: String)

signal towerUpgraded(upgradeType: Enums.UpgradeType, towerName: String, upgradeLevel: int)  
