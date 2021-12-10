extends CanvasLayer

func _ready():
	$HBoxContainer/ColorRect/TileMap/coin/HBoxContainer/Label.text = str(Values.coins)
	$HBoxContainer/ColorRect/TileMap/life/HBoxContainer/Label.text = str(Values.lifes)
