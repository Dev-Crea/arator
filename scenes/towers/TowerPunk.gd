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
onready var resource_icon = "res://assets/units/punk/icon.png"

func _ready():
	animation_idle()
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

func animation_hurt():
	$Container/AnimatedSprite.play("hurt")

func animation_death():
	$Container/AnimatedSprite.play("death")

func animation_idle():
	$Container/AnimatedSprite.play("idle")

func animation_attack():
	$Container/AnimatedSprite.play("attack")

func _on_Degat_area_shape_entered(_area_rid, area, _area_shape_index, _local_shape_index):
	# print("[_on_Degat_area_shape_entered] Tower punk have damage ! ", area.is_in_group("mobs"))
	# print(area)
	if area.is_in_group("towers"):
		print("damage towers")
	
	if area.is_in_group("level0"):
		print("damage level0")
	
	if area.is_in_group("mobs"):
		print("damage mobs")
		# animation_hurt()
	
	# print(area.group)

func _on_Degat_area_shape_exited(_area_rid, area, _area_shape_index, _local_shape_index):
	# print("[_on_Degat_area_shape_exited] Tower punk stop degat ! ", area.is_in_group("mobs"))
	if area.is_in_group("mobs"):
		animation_idle()

func _on_Attack_area_shape_entered(_area_rid, area, area_shape_index, _local_shape_index):
	# print("[_on_Attack_area_shape_entered] Tower punk attack ! ", area.is_in_group("mobs"))
	if area.is_in_group("mobs"):
		animation_attack()
		area.shape_owner_get_owner(area_shape_index).get_parent().get_parent().emit_signal("hit", attack)

	if area.is_in_group("towers"):
		print("damage towers")
	
	if area.is_in_group("level0"):
		print("damage level0")
	
	if area.is_in_group("mobs"):
		print("damage mobs")

func _on_Attack_area_shape_exited(_area_rid, area, _area_shape_index, _local_shape_index):
	if area != null:
		# print("[_on_Attack_area_shape_exited] Tower punk stop attack mob ! ", area.is_in_group("mob"))
		if area.is_in_group("mob"):
			animation_idle()

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
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed() and hover:
		Values.select_icon = resource_icon
		Values.select_life = "Vie : "+ str(life)
		Values.select_damage = "Dégats : " + str(attack)
		Values.select_range = "Portée : " + str(range_attack)
		Values.select_level = "Niveaux : " + str(level)
		Values.update_select_info()
		selected = true

func _hover():
	var mouse = get_global_mouse_position()
	
	return (
		mouse.x > $Container/Hover.global_position.x - 16 and
		mouse.x < $Container/Hover.global_position.x + 16 and
		mouse.y > $Container/Hover.global_position.y - 16 and 
		mouse.y < $Container/Hover.global_position.y + 16
	)


func _on_Attack_area_entered(area):
	print("_on_Attack_area_entered")
	if area.is_in_group("towers"):
		print("damage towers")
	
	if area.is_in_group("level0"):
		print("damage level0")
	
	if area.is_in_group("mobs"):
		print("damage mobs")
