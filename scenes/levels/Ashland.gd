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

var tower_selected = null
var waves_current = 5
var waves_timeout = 0

func _ready():
	Values.initialize_level(15, 25)

func _process(delta):
	waves_timeout += delta
	if waves_timeout > WAVES_MOB_INTERVAL:
		print("waves_timeout > WAVES_MOB_INTERVAL")
		emit_signal("timeout")
		# Reset timer
		waves_timeout = 0

func _physics_process(delta):
	$MobPath/MobPathLocation.offset += 35 * delta
	# mobPathLocation.offset += velocity * delta
	# mobPathLocation.set_offset(mobPathLocation.get_offset() + velocity * delta)
	# pathToFollow.offset += 350 * delta

func _generate_mob():
	var mobInstance = load("res://scenes/mobs/MobRat.tscn").instance()
	
	# mob.position = $MobSpawner.position
	# $MobPath/MobPathLocation.duplicate().add_child(mob)
	$MobPath/MobPathLocation.add_child(mobInstance)

func _on_Node2D_building(tower, position):
	var building = load("res://scenes/towers/" + tower).instance()
	building.position = position
	building.pay()
	$TileMap.add_child(building)

func _on_Waves_timeout():
	print("_on_Waves_timeout")
	_generate_mob()
