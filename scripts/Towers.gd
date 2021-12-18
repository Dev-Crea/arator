extends Node

const PUNK = "punk"
const CYBORG = "cyborg"

onready var node = null
onready var current = null
onready var selected = false
onready var price = null
onready var resource = null

## Generic methods
func select(tower_name):
	selected = true
	current = tower_name
	price = call(tower_name + "_price")
	resource = call(tower_name + "_scene")

func unselect():
	selected = false
	price = null
	resource = null

## Tower PUNK
func punk_price():
	return 2

func punk_scene():
	return "TowerPunk.tscn"

func punk_area_attack():
	return 3

func punk_price_level():
	return punk_price() + 1

## Tower CYBORG
func cyborg_price():
	return 5

func cyborg_scene():
	return "TowerCyborg.tscn"

func cyborg_area_attack():
	return 4

func cyborg_price_level():
	return punk_price() + 2
