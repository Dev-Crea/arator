extends Node2D

# warning-ignore:unused_signal
signal check_build

func _ready():
	$Area/Bulding.color = Constants.COLOR_BUILD_VALID

func scaling_area_attack():
	# print("scaling_area_attack")
	if (Towers.current != null):
		var size = Towers.call(Towers.current + "_area_attack")
# warning-ignore:integer_division
		var position = int(((Constants.TILE_SIZE / 2) * size) - 16) * -1
		
		$Area/AttackAreaZone.rect_scale = Vector2(size, size)
		$Area/AttackAreaZone.rect_position = Vector2(position, position)

func _check_build_authorized(body):
	# print("build authorized ? ", body.get_groups())
	return body.is_in_group("maps") or body.is_in_group("towers")

func _on_BuilderZone_visibility_changed():
	# print("_on_BuilderZone_visibility_changed")
	if visible:
		scaling_area_attack()

func _on_Area2D_area_entered(area):
	# print("_on_Area2D_area_entered")
	if _check_build_authorized(area):
		$Area/Bulding.color = Constants.COLOR_BUILD_INVALID

func _on_Area2D_area_exited(area):
	# print("_on_Area2D_area_exited")
	if _check_build_authorized(area):
		$Area/Bulding.color = Constants.COLOR_BUILD_VALID
