extends Node

# warning-ignore:unused_signal
signal new_wave

onready var chronometer = Constants.START_TIME

func _ready():
	$Level.add_child(Maps.next_level())

func _input(event):
	_quit_game(event)
	_move_camera(event)
	_build_tower(event)

func _process(_delta):
	if Towers.selected:
		$BuilderZone/Area.rect_global_position = _arround_position()

func _quit_game(event):
	if Actions.quitGame(event):
		get_tree().quit() 

func _move_camera(event):
	if Actions.cameraRight(event) and $Camera.limit_right - _width() > $Camera.position.x:
		$Camera.position.x += Constants.TILE_SIZE
	
	if Actions.cameraLeft(event) and $Camera.limit_left < $Camera.position.x:
		$Camera.position.x -= Constants.TILE_SIZE

	if Actions.cameraBottom(event) and ($Camera.limit_bottom + Constants.TILE_SIZE * 2) - _height() > $Camera.position.y:
		$Camera.position.y += Constants.TILE_SIZE

	if Actions.cameraTop(event) and $Camera.limit_top < $Camera.position.y:
		$Camera.position.y -= Constants.TILE_SIZE

func _build_tower(event):
	if (
		event is InputEventMouseButton and 
		event.button_index == BUTTON_LEFT and 
		event.is_pressed()
	):
		if Towers.selected:
			if Values.coins >= Towers.price:
				_building_tower()
		#else:
			#print("unselect")
			# Towers.unselect()
		
	if (
		event is InputEventMouseButton and 
		event.button_index == BUTTON_RIGHT and 
		event.is_pressed() and 
		Towers.selected
	):
		_building_stop()

func _building_stop():
	$BuilderZone.visible = false

func _building_tower():
	_building_stop()
	var position = $BuilderZone/Area/Bulding.rect_global_position
	
	position.x += 16
	position.y += 16
	
	# warning-ignore:return_value_discarded
	$Level.get_children()[0].emit_signal("building", position)

func _width():
	return OS.get_real_window_size()[0]

func _height():
	return OS.get_real_window_size()[1]

func _arround_position():
	var position = get_viewport().get_mouse_position() / Constants.TILE_SIZE
	
	return Vector2(int(position.x) * Constants.TILE_SIZE, int(position.y) * Constants.TILE_SIZE)

func _on_Build_body_entered(body):
	if _check_build_authorized(body):
		$BuilderZone/Area/Bulding.color = Constants.COLOR_BUILD_INVALID

func _on_Build_body_exited(body):
	if _check_build_authorized(body):
		$BuilderZone/Area/Bulding.color = Constants.COLOR_BUILD_VALID

func _check_build_authorized(body):
	# print("build authorized ? ", body.get_groups())
	return body.is_in_group("maps") or body.is_in_group("towers")

func _on_tower_punk_pressed():
	Towers.select(Towers.PUNK)
	$BuilderZone.visible = true

func _on_tower_cyborg_pressed():
	Towers.select(Towers.CYBORG)
	$BuilderZone.visible = true

func _on_Main_new_wave():
	print("_on_Main_new_wave")

func _on_Main_start_wave():
	$StartTime/Chrono.disconnect("timeout", self, "_on_Chrono_timeout")
	# $StartTime/Chrono.free()
	$StartTime.disconnect("timeout", self, "_on_Main_start_wave")
	# $TimerStart.free()
	$TimerStart/CenterContainer.visible = false
	Values.start = true

func _on_Chrono_timeout():
	chronometer -= 1
	$TimerStart/CenterContainer/Label.text = "Start in "+str(chronometer)

func _on_update_pressed():
	Towers.node.emit_signal("update")
