extends Node2D

# warning-ignore:unused_signal
signal building(position)

func _ready():
	Values.initialize_level(15, 25, Waves.ashland())

func _physics_process(delta):
	for path in $Paths.get_children():
		var follow = path.get_node("Path2D/PathFollow2D")
		follow.set_offset(follow.offset + path.velocity * delta)
	
	# Wave ending !
	if Values.start and $Paths.get_child_count() == 0:
		# print("[AshLand] if Waves.ashland().size() > waves_current + 1 : "+str(Waves.ashland().size() > Waves.current + 1))
		if Waves.ashland().size() > Waves.current + 1:
			# rint("[AshLand] launch next waves in ...")
			Waves.emit_signal("end_wave", Waves.ashland())
		else:
			print("[AshLand] all waves has executed")

func generate_mob():
	print("Generate MOB !")
	var mobInstance = load("res://scenes/mobs/MobRat.tscn").instance()
	mobInstance.set_curve($MobPathTemplate.get_curve())
	$Paths.add_child(mobInstance)

func _on_Node2D_building(position):
	var building = load("res://scenes/towers/" + Towers.resource).instance()
	building.position = position
	building.pay()
	$TileMap.add_child(building)
	Towers.unselect()

func _on_MobOut_area_shape_entered(_area_rid, area, _area_shape_index, _local_shape_index):
	Values.lifes -= 1
	Values.update_lifes()
	area.get_parent().get_parent().get_parent().queue_free()
