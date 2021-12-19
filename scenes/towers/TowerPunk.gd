extends Node2D

# warning-ignore:unused_signal
signal build(valid)
# warning-ignore:unused_signal
signal building
# warning-ignore:unused_signal
signal attack_ended
# warning-ignore:unused_signal
signal update

onready var attack_mob = null
onready var list_mobs = []
onready var hover = false
onready var selected = false
onready var life = 20
onready var attack = 5
onready var level = 0
onready var level_max = 3
onready var range_attack = 1
onready var resource_icon = "res://assets/units/punk/icon.png"

func update_level(add_life, add_attack, add_range_attack):
	life += add_life
	attack += add_attack
	range_attack += add_range_attack
	update_info_level()
	Values.emit_signal("buy", Towers.punk_price_level())
	$BuilderZone.update_scaling_area_attack(add_range_attack)

func level_1():
	print("update to level 1")
	update_level(5, 3, 0.5)

func level_2():
	print("update to level 2")
	update_level(10, 5, 0.5)

func level_3():
	print("update to level 3")
	update_level(2, 15, 1)

func _ready():
	animation_idle()
	attack_area(true)
	hover = true

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
	Values.emit_signal("buy", Towers.punk_price())

func animation_hurt():
	$Container/AnimatedSprite.play("hurt")

func animation_death():
	$Container/AnimatedSprite.play("death")

func animation_idle():
	$Container/AnimatedSprite.play("idle")

func animation_attack():
	$Container/AnimatedSprite.play("attack")

func _physics_process(_delta):
	#if _hover():
	#	attack_area(true)
	#	hover = true
	#else:
	#	attack_area(false)
	#	hover = false
	pass

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed() and hover:
		update_info_level()

func update_info_level():
	Values.select_icon = resource_icon
	Values.select_life = "Vie : "+ str(life)
	Values.select_damage = "Dégats : " + str(attack)
	Values.select_range = "Portée : " + str(range_attack)
	Values.select_level = "Niveaux : " + str(level)
	Values.update_select_info()
	selected = true
	Towers.node = self

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
		#print("[_on_Attack_area_entered] ", str(area))
		#print("[_on_Attack_area_entered] ", str(area.get_groups()))
		if area.is_in_group("mobs"):
			attack_mob = area.get_parent().get_parent().get_parent()
			#print("[_on_Attack_area_entered] start damage on unit : ", attack_mob)
			attack_mob.emit_signal("hit", 5, self)

		list_mobs.push_front(area)
		# list_mobs.push_back(attack_mob)
		#print(list_mobs)

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

func _on_update_level():
	if updatable():
		level += 1
		call("level_"+str(level))

func updatable():
	return level < level_max and Towers.punk_price_level() < Values.coins
