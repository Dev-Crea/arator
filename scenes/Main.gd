extends Node

const CAMERA_MOVE = 32
const BUILD_VALID = Color(0, 255, 0, 100)
const BUILD_INVALID = Color(255, 0, 0, 100)

var selected = false
var tower_selected = false
var tower_price = 0
var tower_resource = null

func _input(event):
	_quit_game(event)
	_move_camera(event)
	_move_background()
	_build_tower(event)

func _quit_game(event):
	if(event.is_pressed() and event is InputEventKey):
		if(event.scancode == KEY_ESCAPE):
			get_tree().quit() 

func _move_camera(event):
	if Actions.cameraRight(event) and $Camera.limit_right - _width() > $Camera.position.x:
		$Camera.position.x = $Camera.position.x + CAMERA_MOVE
	
	if Actions.cameraLeft(event) and $Camera.limit_left < $Camera.position.x:
		$Camera.position.x -= CAMERA_MOVE

	if Actions.cameraBottom(event) and ($Camera.limit_bottom + CAMERA_MOVE * 2) - _height() > $Camera.position.y:
		$Camera.position.y += CAMERA_MOVE

	if Actions.cameraTop(event) and $Camera.limit_top < $Camera.position.y:
		$Camera.position.y -= CAMERA_MOVE

func _move_background():

	$Background.rect_global_position.x = $Camera.position.x
	$Background.rect_global_position.y = $Camera.position.y

func _build_tower(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
		if tower_selected:
			if Values.coins >= tower_price:
				_building_tower()

	if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT and event.is_pressed() and tower_selected:
		_building_stop()

func _building_stop():
	tower_selected = false
	tower_price = null
	$CursorBuild.visible = false

func _building_tower():
	_building_stop()
	# warning-ignore:return_value_discarded
	$Ashland.emit_signal("building", tower_resource, $CursorBuild.rect_global_position)

func _width():
	return OS.get_real_window_size()[0]

func _height():
	return OS.get_real_window_size()[1]

func _on_tower_punk_pressed():
	tower_selected = true
	tower_price = 2
	tower_resource = "TowerPunk.tscn"
	$CursorBuild.visible = true

func _process(_delta):
	if tower_selected:
		$CursorBuild.rect_global_position = _arround_position()

func _arround_position():
	var position = get_viewport().get_mouse_position() / CAMERA_MOVE
	
	return Vector2(int(position.x) * CAMERA_MOVE, int(position.y) * CAMERA_MOVE)

func _on_Build_body_entered(body):
	if _check_build_authorized(body):
		$CursorBuild.color = BUILD_INVALID

func _on_Build_body_exited(body):
	if _check_build_authorized(body):
		$CursorBuild.color = BUILD_VALID

func _check_build_authorized(body):
	return body.is_in_group("map") or body.is_in_group("tower")
