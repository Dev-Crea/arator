extends Node2D

# warning-ignore:unused_signal
signal build(valid)
# warning-ignore:unused_signal
signal building

onready var hover = false
onready var selected = false
onready var life = 20
onready var attack = 5
onready var level = 1
onready var range_attack = 1

func _ready():
	if !Values.is_connected("buy", Values, "update_coins"):
		# warning-ignore:return_value_discarded
		Values.connect("buy", Values, "update_coins")

func attack_area(valid = true):
	$Container/AttackArea.visible = valid
	$Container/AttackArea.material.set_shader_param("swap_color", !valid)

func build_area(valid = true, visible = true):
	$Container/BuildArea.visible = visible
	$Container/BuildArea.color = _build_color(valid)

func _build_color(valid):
	var alpha = 0.001
	
	if valid:
		return Color(0, 255, 0, alpha)
	else:
		return Color(255, 0, 0, alpha)

func pay():
	Values.coins -= Towers.punk_price()
	Values.emit_signal("buy")

func walk():
	$Container/AnimatedSprite.play("walk")

func hurt():
	$Container/AnimatedSprite.play("hurt")

func death():
	$Container/AnimatedSprite.play("death")

func idle():
	$Container/AnimatedSprite.play("idle")

func _on_Degat_area_shape_entered(_area_rid, area, _area_shape_index, _local_shape_index):
	print("[_on_Degat_area_shape_entered] Tower punk have damage ! ", area.is_in_group("mob"))
	$Container/AnimatedSprite.play("hurt")

func _on_Degat_area_shape_exited(_area_rid, area, _area_shape_index, _local_shape_index):
	print("[_on_Degat_area_shape_exited] Tower punk stop degat ! ", area.is_in_group("mob"))
	$Container/AnimatedSprite.play("idle")

func _on_Attack_area_shape_entered(_area_rid, area, area_shape_index, _local_shape_index):
	print("[_on_Attack_area_shape_entered] Tower punk attack ! ", area.is_in_group("mob"))
	if area.is_in_group("mob"):
		$Container/AnimatedSprite.play("attack")
		area.shape_owner_get_owner(area_shape_index).get_parent().get_parent().emit_signal("hit", attack)

func _on_Attack_area_shape_exited(_area_rid, area, _area_shape_index, _local_shape_index):
	if area != null:
		print("[_on_Attack_area_shape_exited] Tower punk stop attack mob ! ", area.is_in_group("mob"))
		$Container/AnimatedSprite.play("idle")

func _on_Hover_mouse_entered():
	print("[_on_Hover_mouse_entered] Hover !")
	attack_area(true)

func _on_Hover_mouse_exited():
	print("[_on_Hover_mouse_exited] END Hover !")
	attack_area(false)

func _physics_process(_delta):
	if _hover():
		attack_area(true)
		hover = true
	else:
		attack_area(false)
		hover = false

func _input(event):
	#print("Hover : ", str(hover))
	#print("Select : ", str(selected))
	
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed() and hover:
		Values.select_icon = "res://assets/units/punk/Punk_icon.png"
		Values.select_life = "Vie : "+ str(life)
		Values.select_damage = "Dégats : " + str(attack)
		Values.select_range = "Portée : " + str(range_attack)
		Values.select_level = "Niveaux : " + str(level)
		Values.update_select_info()
		selected = true
	
	#if selected and !hover:
	#	Values.unselect_info()
	#	selected = false

func _hover():
	var mouse = get_global_mouse_position()
	
	var x_min = $Container/Hover.global_position.x - 16
	var x_max = $Container/Hover.global_position.x + 16
	
	var y_min = $Container/Hover.global_position.y - 16
	var y_max = $Container/Hover.global_position.y + 16
	
	return mouse.x > x_min and mouse.x < x_max and mouse.y > y_min and mouse.y < y_max

