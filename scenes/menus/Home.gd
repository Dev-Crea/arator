extends Control

func _ready():
	$CenterContainer/HBoxContainer/menu/version.text = Constants.VERSION

func _on_start_pressed():
	pass # Replace with function body.

func _on_quit_pressed():
	get_tree().quit() 
