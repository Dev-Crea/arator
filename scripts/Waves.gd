extends Node

# warning-ignore:unused_signal
signal timeout_chronometer
# warning-ignore:unused_signal
signal timeout_start_time
# warning-ignore:unused_signal
signal end_wave(map_max_mob)

onready var max_mob = 0
onready var mob_generated = 0
onready var mob_death = 0
onready var current = 0
onready var timeout = 0
onready var chronometer = Constants.START_TIME

func _ready():
	# warning-ignore:return_value_discarded
	connect("end_wave", self, "_on_wave_end")
	# warning-ignore:return_value_discarded
	connect("timeout_start_time", self, "_on_timeout_start_time")
	# warning-ignore:return_value_discarded
	connect("timeout_chronometer", self, "_on_timeout_chronometer")

func _process(delta):
	timeout += delta
	if timeout > Constants.WAVES_MOB_INTERVAL and mob_generated < max_mob and Values.start:
		emit_signal("timeout_chronometer")
		timeout = 0
		mob_generated += 1
		get_tree().get_current_scene().get_node("Level").get_child(0).generate_mob()

func _on_wave_end(map_max_mob):
	print("[Waves] _on_wave_end()")
	Values.start = false
	current += 1
	mob_generated = 0
	max_mob = map_max_mob[current]
	chronometer = Constants.START_TIME
	
	get_tree().get_current_scene().get_node("StartTime").start()
	get_tree().get_current_scene().get_node("StartTime/Chrono").start()
	
	get_tree().get_current_scene().get_node("TimerStart/CenterContainer/Label").text = "Start in "+str(chronometer)
	get_tree().get_current_scene().get_node("TimerStart/CenterContainer").visible = true
	
	# warning-ignore:return_value_discarded
	get_tree().get_current_scene().get_node("StartTime").connect("timeout", self, "_on_timeout_start_time")
	# warning-ignore:return_value_discarded
	get_tree().get_current_scene().get_node("StartTime/Chrono").connect("timeout", self, "_on_timeout_chronometer")

func _on_timeout_start_time():
	print("[Waves] _on_timeout_start_time")
	get_tree().get_current_scene().get_node("StartTime").disconnect("timeout", self, "_on_timeout_start_time")
	get_tree().get_current_scene().get_node("StartTime").stop()
	get_tree().get_current_scene().get_node("StartTime/Chrono").disconnect("timeout", self, "_on_timeout_chronometer")
	get_tree().get_current_scene().get_node("StartTime/Chrono").stop()
	get_tree().get_current_scene().get_node("TimerStart/CenterContainer").visible = false
	Values.start = true
	get_tree().get_current_scene().get_node("Camera/HUD/HBoxContainer/ColorRect/TileMap/Control/HBoxContainer/game/waves/HBoxContainer/current").text = str(1 + current)

func _on_timeout_chronometer():
	print("[Waves] _on_timeout_chronometer")
	chronometer -= 1
	get_tree().get_current_scene().get_node("TimerStart/CenterContainer/Label").text = "Start in "+str(chronometer)

func ashland():
	return [
		1,
		2,
		4
	]

func earthland():
	return [
		1,
		2,
		4,
		8,
		16
	]
