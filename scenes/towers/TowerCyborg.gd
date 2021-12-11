extends "res://scenes/towers/TowerPunk.gd"

func pay():
	Values.coins -= Towers.cyborg_price()
	Values.emit_signal("buy")
