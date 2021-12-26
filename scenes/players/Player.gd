extends Node2D

var type: String
var pseudo: String
var life: int
var color: Color

func _ready():
	print("Create a New Challenger !!")

func set_pseudo(value):
	pseudo = value
#func _init(player_pseudo, player_type, player_life, player_color):
#	self.type = player_type
#	self.pseudo = player_pseudo
#	self.life = player_life
#	self.color = player_color
