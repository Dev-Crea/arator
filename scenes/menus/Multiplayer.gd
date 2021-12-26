extends Control

signal receive_message(message)

func _ready():
	var player = _define_player()
	
	Values.network.configure(
		"Multiplayer",
		player,
		self
	)
	_configure_window()
	_add_list_roles()

func _define_player():
	if Values.multi_player_hosting():
		return {
			"pseudo": "Commander",
			"type": "Commander",
			"color": Constants.PLAYER_1_COLOR
		}
	else:
		return {
			"pseudo": "Doc",
			"type": "Doc",
			"color": Constants.PLAYER_2_COLOR
		}

func _get_color_player():
	var color = null
	
	match Values.count_player:
		1: color = Constants.PLAYER_1_COLOR
		2: color = Constants.PLAYER_2_COLOR
		3: color = Constants.PLAYER_3_COLOR
		4: color = Constants.PLAYER_4_COLOR
	
	return color

func _add_list_roles():
	$HBoxContainer/VBoxContainer2/HBoxContainer/Player/HBoxContainer/ColorPlayer.color = _get_color_player()
	$HBoxContainer/VBoxContainer2/HBoxContainer/ListRole.add_item("Commander")
	$HBoxContainer/VBoxContainer2/HBoxContainer/ListRole.add_item("Doc")
	$HBoxContainer/VBoxContainer2/HBoxContainer/ListRole.add_item("Tech")
	$HBoxContainer/VBoxContainer2/HBoxContainer/ListRole.add_item("Tank")

func _configure_window():
	$HBoxContainer/VBoxContainer2/ChatInput.grab_focus()

func _on_ChatInput_text_entered(new_text):
	var id = get_tree().get_network_unique_id()
	$HBoxContainer/VBoxContainer2/ChatInput.text = ""
	
	Values.network.send_message("\n["+str(id)+"] "+new_text)

func _on_Cancel_pressed():
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://scenes/menus/Home.tscn")

func _on_launch_game_pressed():
	print("Launch Game !!")

func _on_ListRole_item_selected(index):
	var color_with_alpha = _get_color_player()
	var list = $HBoxContainer/VBoxContainer2/HBoxContainer/ListRole
	
	color_with_alpha.a = 0.001
	for index_item in (list.items.size() - 1):
		if index == index_item:
			list.set_item_custom_bg_color(index, color_with_alpha)
			# list.set_item_text(index, str(list.get_item_text(index))+" ["+str(get_tree().get_rpc_sender_id())+"]")
		else:
			var clr = list.get_item_custom_bg_color(index_item)
			
			if clr == color_with_alpha:
				list.set_item_custom_bg_color(index_item, Color(0, 0, 0, 0))

func _on_ServerMultiplayer_receive_message(message):
	$HBoxContainer/VBoxContainer2/ChatOutput.text += message
