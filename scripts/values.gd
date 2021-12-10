extends Node

# warning-ignore:unused_signal
signal buy()
# warning-ignore:unused_signal
signal enemi_escape()

var lifes: int
var coins: int

func initialize_level(level_lifes, level_coins):
	self.lifes = level_lifes
	self.coins = level_coins

func update_coins():
	$"/root/Main/Camera/HUD/HBoxContainer/ColorRect/TileMap/coin/HBoxContainer/Label".text = str(coins)

func update_lifes():
	$"/root/Main/Camera/HUD/HBoxContainer/ColorRect/TileMap/life/HBoxContainer/Label".text = str(lifes)
