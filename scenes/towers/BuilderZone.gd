extends Node2D

func _ready():
	$Area/Bulding.color = Constants.COLOR_BUILD_VALID

func scaling_area_attack():
	if (Towers.current != null):
		var size = Towers.call(Towers.current + "_area_attack")
		# warning-ignore:integer_division
		var position = int(((Constants.TILE_SIZE / 2) * size) - 16) * -1
		
		$Area/AttackAreaZone.rect_scale = Vector2(size, size)
		$Area/AttackAreaZone.rect_position = Vector2(position, position)

func _on_BuilderZone_visibility_changed():
	if visible:
		scaling_area_attack()
