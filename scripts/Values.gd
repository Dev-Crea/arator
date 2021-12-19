extends Node

# warning-ignore:unused_signal
signal buy(value)
# warning-ignore:unused_signal
signal enemi_escape()

var current_wave = 0
var start = false
var lifes: int
var coins: int
var waves: int
var select_icon: String
var select_life: String
var select_damage: String
var select_level: String
var select_range: String

func _ready():
	# warning-ignore:return_value_discarded
	self.connect("buy", self, "buy_object")

func initialize_level(level_lifes, level_coins, array_waves):
	self.lifes = level_lifes
	self.coins = level_coins
	self.waves = array_waves.size()
	
	self.select_icon = ""
	self.select_life = ""
	self.select_damage = ""
	self.select_level = ""
	self.select_range = ""
	_path("info/ColorRect/HBoxContainer").visible = false
	
	update_coins()
	update_lifes()
	update_waves()
	
	Waves.current = 0
	Waves.max_mob = array_waves[Waves.current]

func update_coins():
	_path("game/VBoxContainer/coins/Label").text = str(coins)

func update_lifes():
	_path("game/VBoxContainer/lifes/Label").text = str(lifes)

func update_waves():
	_path("game/waves/HBoxContainer/total").text = str(waves)

func unselect_info():
	select_life = ""
	select_damage = ""
	select_range = ""
	select_level = ""
	_path("info/ColorRect/HBoxContainer").visible = false

func update_select_info():
	_path("info/ColorRect/HBoxContainer").visible = true
	if !select_icon.empty():
		_path("info/ColorRect/HBoxContainer/icon").texture = load(select_icon)
	_path("info/ColorRect/HBoxContainer/VBoxContainer/life").text = str(select_life)
	_path("info/ColorRect/HBoxContainer/VBoxContainer/damage").text = str(select_damage)
	_path("info/ColorRect/HBoxContainer/VBoxContainer2/level").text = str(select_level)
	_path("info/ColorRect/HBoxContainer/VBoxContainer2/range").text = str(select_range)
	if Towers.node != null:
		_path("info/ColorRect/HBoxContainer/update").disabled = !Towers.node.updatable()

func _path(more):
	return get_node("/root/Main/Camera/HUD/HBoxContainer/ColorRect/TileMap/Control/HBoxContainer/" + more)

func buy_object(value):
	self.coins -= value
	update_coins()
