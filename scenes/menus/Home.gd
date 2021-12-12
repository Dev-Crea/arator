extends Control

func _ready():
	$CenterContainer/HBoxContainer/menu/version.text = Constants.VERSION

func _on_start_pressed():
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://scenes/Main.tscn")

func _on_quit_pressed():
	get_tree().quit() 
