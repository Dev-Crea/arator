extends Node

const PUNK = "punk"
const CYBORG = "cyborg"

onready var current = null
onready var selected = false
onready var price = null
onready var resource = null

func select(tower_name):
	selected = true
	current = tower_name
	price = call(tower_name + "_price")
	resource = call(tower_name + "_scene")

func unselect():
	selected = false
	price = null
	resource = null

func punk_price():
	return 2

func punk_scene():
	return "TowerPunk.tscn"

func cyborg_price():
	return 5

func cyborg_scene():
	return "TowerCyborg.tscn"
