extends Node2D

# warning-ignore:unused_signal
signal building(position)
# warning-ignore:unused_signal
signal wave_ending
signal timeout

const WAVES_MOB_INTERVAL = 1

var waves_max_mob = 0
var waves_mob_generated = 0
var tower_selected = null
var waves_current = 0
var waves_timeout = 0

func _ready():
	Values.current_wave = 0
	Values.initialize_level(15, 25, Waves.ashland())
	waves_max_mob = Waves.ashland()[waves_current]

func _process(delta):
	waves_timeout += delta
	if waves_timeout > WAVES_MOB_INTERVAL and waves_mob_generated < waves_max_mob and Values.start:
		emit_signal("timeout")
		waves_timeout = 0
		waves_mob_generated += 1
		# waves_current += 1

func _physics_process(delta):
	for path in $Paths.get_children():
		var follow = path.get_node("Path2D/PathFollow2D")
		follow.set_offset(follow.offset + path.velocity * delta)
	
	if Values.start and $Paths.get_child_count() == 0:
		print("No mob in maps")
		Values.start = 0
		waves_current += 1
		waves_mob_generated = 0
		waves_max_mob = Waves.ashland()[waves_current]

func _generate_mob():
	var mobInstance = load("res://scenes/mobs/MobRat.tscn").instance()
	mobInstance.set_curve($MobPathTemplate.get_curve())
	$Paths.add_child(mobInstance)

func _on_Node2D_building(position):
	var building = load("res://scenes/towers/" + Towers.resource).instance()
	building.position = position
	building.pay()
	$TileMap.add_child(building)
	Towers.unselect()

func _on_Waves_timeout():
	print("_on_Waves_timeout")
	_generate_mob()

func _on_MobOut_area_shape_entered(_area_rid, area, _area_shape_index, _local_shape_index):
	Values.lifes -= 1
	Values.update_lifes()
	area.get_parent().get_parent().get_parent().queue_free()
