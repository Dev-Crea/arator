extends Node

var current_level = null
var node = null

func next_level():
	if current_level == null:
		return level_ashland()
	else:
		return level_earthland()

func levels():
	return [
		"AshLand",
		"EarthLand"
	]

func level_ashland():
	current_level = levels()[0]
	return load("res://scenes/levels/AshLand.tscn").instance()

func level_earthland():
	current_level = levels()[1]
	return load("res://scenes/levels/EarthLand.tscn").instance()
