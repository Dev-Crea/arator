extends Node

func cameraRight(event):
	return (
		Input.is_action_pressed("ui_right") or
		Input.is_key_pressed(KEY_D) or
		(
			event is InputEventMouseButton and 
			event.button_index == BUTTON_WHEEL_UP and Input.is_key_pressed(KEY_CONTROL)
		)
	)

func cameraLeft(event):
	return (
		Input.is_action_pressed("ui_left") or 
		Input.is_key_pressed(KEY_Q) or
		(
			event is InputEventMouseButton and 
			event.button_index == BUTTON_WHEEL_DOWN and Input.is_key_pressed(KEY_CONTROL)
		)
	)

func cameraBottom(event):
	return (
		Input.is_action_pressed("ui_down") or 
		Input.is_key_pressed(KEY_S) or
		(
			event is InputEventMouseButton and 
			event.button_index == BUTTON_WHEEL_DOWN
		)
	)
	
func cameraTop(event):
	return (
		Input.is_action_pressed("ui_up") or 
		Input.is_key_pressed(KEY_Z) or
		(
			event is InputEventMouseButton and 
			event.button_index == BUTTON_WHEEL_UP
		)
	)
