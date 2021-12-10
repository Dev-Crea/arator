extends Node2D

# warning-ignore:unused_signal
signal building(tower, position)

var tower_selected = null

func _ready():
	Values.initialize_level(150, 250)
	
	generate_mobs()

func generate_mobs():
	generate_mob()

func generate_mob():
	pass

func _on_Node2D_building(tower, position):
	var building = load("res://scenes/towers/TowerPunk.tscn").instance()
	building.position = position
	building.pay()
	$TileMap.add_child(building)
