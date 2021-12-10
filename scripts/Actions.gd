extends Node

func cameraRight():
	return (Input.is_action_pressed("ui_right") or Input.is_key_pressed(KEY_D))

func cameraLeft():
	return Input.is_action_pressed("ui_left") or Input.is_key_pressed(KEY_Q)

func cameraBottom():
	return Input.is_action_pressed("ui_down") or Input.is_key_pressed(KEY_S)
	
func cameraTop():
	return Input.is_action_pressed("ui_up") or Input.is_key_pressed(KEY_Z)
