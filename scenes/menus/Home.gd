extends Control

func _ready():
	$CenterContainer/HBoxContainer/menu/version.text = Constants.VERSION

func _on_start_pressed():
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://scenes/Main.tscn")

func _on_quit_pressed():
	get_tree().quit() 

func _on_game_multi_create_pressed():
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://scenes/menus/ServerMultiplayer.tscn")

func _on_game_multi_join_pressed():
	pass # Replace with function body.
