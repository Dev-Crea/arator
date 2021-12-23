extends Node2D

var type: String
var pseudo: String
var life: int
var color: Color

func _ready():
	print("Create a New Challenger !!")

func _init(pseudo, type, life, color):
	self.type = type
	self.pseudo = pseudo
	self.life = life
	self.color = color
