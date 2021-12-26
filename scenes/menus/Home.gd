extends Control

onready var Log = $Logger

func _ready():
	Log.debug("Test logger")
	$CenterContainer/HBoxContainer/menu/version.text = Constants.VERSION

func _on_start_pressed():
	_change_scene("res://scenes/Main.tscn")

func _on_quit_pressed():
	get_tree().quit() 

func _on_game_multi_create_pressed():
	_change_scene("res://scenes/menus/Multiplayer.tscn")

func _on_game_multi_join_pressed():
	if $"CenterContainer/HBoxContainer/menu/multi-join/TextEdit".text != "":
		Values.multi_player_host = $"CenterContainer/HBoxContainer/menu/multi-join/TextEdit".text
		_change_scene("res://scenes/menus/Multiplayer.tscn")
	else:
		print("Missing IP !")

func _change_scene(scene):
	# warning-ignore:return_value_discarded
	get_tree().change_scene(scene)
