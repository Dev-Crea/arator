extends Node2D

# warning-ignore:unused_signal
signal build(valid)
# warning-ignore:unused_signal
signal building
# warning-ignore:unused_signal
signal attack_ended

onready var attack_mob = null
onready var list_mobs = []
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
	$BuilderZone/Area/AttackAreaZone.visible = valid
	$BuilderZone/Area/AttackAreaZone.material.set_shader_param("swap_color", !valid)

func build_area(valid = true, visible = true):
	$BuilderZone/Area/Bulding.visible = visible
	$BuilderZone/Area/Bulding.color = _build_color(valid)

func _build_color(valid):
	if valid:
		return Constants.COLOR_BUILD_VALID
	else:
		return Constants.COLOR_BUILD_INVALID

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
	if (attack_mob == null):
		print("[_on_Attack_area_entered] ", str(area))
		print("[_on_Attack_area_entered] ", str(area.get_groups()))
		if area.is_in_group("mobs"):
			attack_mob = area.get_parent().get_parent().get_parent()
			#print("[_on_Attack_area_entered] start damage on unit : ", attack_mob)
			attack_mob.emit_signal("hit", 5, self)

		list_mobs.push_front(area)
		# list_mobs.push_back(attack_mob)
		print(list_mobs)

func _on_Attack_area_exited(area):
	if area.is_in_group("mobs"):
		var mob = area.get_parent().get_parent().get_parent()
		#print("[_on_Attack_area_exited] stop damage on unit : ", mob)
		mob.emit_signal("stop_hit", 5)
		#print("[_on_Attack_area_exited] : ", str(list_mobs.size()))

func _on_TowerPunk_attack_ended():
	#print("_on_TowerPunk_attack_ended")
	attack_mob = null
	list_mobs.pop_front()
	
	#print(list_mobs)
	if !list_mobs.empty():
		attack_mob = list_mobs[0]
		if is_instance_valid(attack_mob):
			#print("[_on_Attack_area_entered] start damage on unit : ", attack_mob)
			attack_mob.emit_signal("hit", 5, self)
