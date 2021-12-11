extends Node2D

# warning-ignore:unused_signal
signal building(tower, position)
# warning-ignore:unused_signal
signal wave_ending
signal timeout

const WAVES = 20
const TIME_START = 5
const WAVES_INTERVAL = 25 			# 25 seconds
const WAVES_MOB_INTERVAL = 1 		# 1 second
const WAVES_MAX_MOB = 3

var tower_selected = null
var waves_current = 0
var waves_timeout = 0

func _ready():
	Values.initialize_level(15, 25)

func _process(delta):
	waves_timeout += delta
	if waves_timeout > WAVES_MOB_INTERVAL and waves_current < WAVES_MAX_MOB :
		emit_signal("timeout")
		waves_timeout = 0
		waves_current += 1

func _physics_process(delta):
	for path in $Paths.get_children():
		var follow = path.get_node("Path2D/PathFollow2D")
		follow.set_offset(follow.offset + path.velocity * delta)

func _generate_mob():
	var mobInstance = load("res://scenes/mobs/MobRat.tscn").instance()
	mobInstance.set_curve($MobPathTemplate.get_curve())
	
	$Paths.add_child(mobInstance)

func _on_Node2D_building(tower, position):
	var building = load("res://scenes/towers/" + tower).instance()
	building.position = position
	building.pay()
	$TileMap.add_child(building)

func _on_Waves_timeout():
	_generate_mob()
