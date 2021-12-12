extends "res://scenes/towers/TowerPunk.gd"

func _ready():
	life = 25
	attack = 25
	range_attack = 2
	resource_icon = "res://assets/units/cyborg/icon.png"

func pay():
	Values.coins -= Towers.cyborg_price()
	Values.emit_signal("buy")
