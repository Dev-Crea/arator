extends Node

const TILE_SIZE = 32
const BUILD_VALID = Color(0, 255, 0, 0.001)
const BUILD_INVALID = Color(255, 0, 0, 0.001)

func _input(event):
	_quit_game(event)
	_move_camera(event)
	_move_background()
	_build_tower(event)

func _quit_game(event):
	if Actions.quitGame(event):
		get_tree().quit() 

func _move_camera(event):
	if Actions.cameraRight(event) and $Camera.limit_right - _width() > $Camera.position.x:
		$Camera.position.x = $Camera.position.x + TILE_SIZE
	
	if Actions.cameraLeft(event) and $Camera.limit_left < $Camera.position.x:
		$Camera.position.x -= TILE_SIZE

	if Actions.cameraBottom(event) and ($Camera.limit_bottom + TILE_SIZE * 2) - _height() > $Camera.position.y:
		$Camera.position.y += TILE_SIZE

	if Actions.cameraTop(event) and $Camera.limit_top < $Camera.position.y:
		$Camera.position.y -= TILE_SIZE

func _move_background():
	$Background.rect_global_position.x = $Camera.position.x
	$Background.rect_global_position.y = $Camera.position.y

func _build_tower(event):
	if (
		event is InputEventMouseButton and 
		event.button_index == BUTTON_LEFT and 
		event.is_pressed()
	):
		if Towers.selected:
			if Values.coins >= Towers.price:
				_building_tower()

	if (
		event is InputEventMouseButton and 
		event.button_index == BUTTON_RIGHT and 
		event.is_pressed() and 
		Towers.selected
	):
		_building_stop()

func _building_stop():
	$CursorBuild.visible = false

func _building_tower():
	_building_stop()
	var position = $CursorBuild.rect_global_position
	
	position.x += 16
	position.y += 16
	
	# warning-ignore:return_value_discarded
	$Ashland.emit_signal("building", position)

func _width():
	return OS.get_real_window_size()[0]

func _height():
	return OS.get_real_window_size()[1]

func _process(_delta):
	if Towers.selected:
		$CursorBuild.rect_global_position = _arround_position()

func _arround_position():
	var position = get_viewport().get_mouse_position() / TILE_SIZE
	
	return Vector2(int(position.x) * TILE_SIZE, int(position.y) * TILE_SIZE)

func _on_Build_body_entered(body):
	if _check_build_authorized(body):
		$CursorBuild.color = BUILD_INVALID

func _on_Build_body_exited(body):
	if _check_build_authorized(body):
		$CursorBuild.color = BUILD_VALID

func _check_build_authorized(body):
	return body.is_in_group("map") or body.is_in_group("tower")

func _on_tower_punk_pressed():
	Towers.select(Towers.PUNK)
	$CursorBuild.visible = true

func _on_tower_cyborg_pressed():
	Towers.select(Towers.CYBORG)
	$CursorBuild.visible = true
