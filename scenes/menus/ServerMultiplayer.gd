extends Control

onready var peer = NetworkedMultiplayerENet.new()

# Player info, associate ID to data
var player_info = {}
# Info we send to other players
var my_info = { 
	name = "", 
	favorite_color = Color8(255, 0, 255),
	role = ""
}
var players_done = []

func _ready():
	_configure_window()
	_connect_network()
	_info_type_network()
	_connect_signals()
	_add_list_roles()
	_color_player()

func _color_player():
	$HBoxContainer/VBoxContainer2/HBoxContainer/Player/HBoxContainer/ColorPlayer.color = _get_color_player()

func _get_color_player():
	var color = null
	
	match Values.count_player:
		1: color = Constants.PLAYER_1_COLOR
		2: color = Constants.PLAYER_2_COLOR
		3: color = Constants.PLAYER_3_COLOR
		4: color = Constants.PLAYER_4_COLOR
	
	return color
func _add_list_roles():
	$HBoxContainer/VBoxContainer2/HBoxContainer/ListRole.add_item("Commander")
	$HBoxContainer/VBoxContainer2/HBoxContainer/ListRole.add_item("Doc")
	$HBoxContainer/VBoxContainer2/HBoxContainer/ListRole.add_item("Tech")
	$HBoxContainer/VBoxContainer2/HBoxContainer/ListRole.add_item("Tank")

func _configure_window():
	$HBoxContainer/VBoxContainer2/ChatInput.grab_focus()

func _connect_network():
	print("[ServerMultiplayer] _ready() | "+str(Values.multi_player_host))
	if Values.multi_player_host == null:
		peer.create_server(Constants.SERVER_PORT, Constants.MAX_PLAYERS)
		$HBoxContainer/VBoxContainer2/HBoxContainer/Player/ListPlayer.add_item("[1] Host")
	else:
		peer.create_client(Values.multi_player_host, Constants.SERVER_PORT)
		
	get_tree().set_network_peer(peer)
	pre_configure_game()

remote func pre_configure_game():
	var selfPeerID = get_tree().get_network_unique_id()
	
	# Load my player
	var my_player = preload("res://scenes/players/Player.tscn").instance()
	my_player.set_name(str(selfPeerID))
	my_player.set_network_master(selfPeerID) # Will be explained later
	get_node("/root/ServerMultiplayer/Players").add_child(my_player)
	
	# Load other players
	for p in player_info:
		var player = preload("res://scenes/players/Player.tscn").instance()
		player.set_name(str(p))
		player.set_network_master(p) # Will be explained later
		get_node("/root/ServerMultiplayer/Players").add_child(player)
	
	if is_instance_valid(Values.multi_player_host):
		# Tell server (remember, server is always ID=1) that this peer is done pre-configuring.
		# The server can call get_tree().get_rpc_sender_id() to find out who said they were done.
		rpc_id(1, "done_preconfiguring")

func _info_type_network():
	if get_tree().is_network_server():
		print("Is network server !")
	else:
		print("Is not network server")

func _connect_signals():
	# warning-ignore:return_value_discarded
	get_tree().connect("network_peer_connected", self, "_player_connected")
	# warning-ignore:return_value_discarded
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	# warning-ignore:return_value_discarded
	get_tree().connect("connected_to_server", self, "_connected_ok")
	# warning-ignore:return_value_discarded
	get_tree().connect("connection_failed", self, "_connected_fail")
	# warning-ignore:return_value_discarded
	get_tree().connect("server_disconnected", self, "_server_disconnected")

func _on_ChatInput_text_entered(new_text):
	var id = get_tree().get_network_unique_id()
	var msg = "\n["+str(id)+"] "+new_text
	$HBoxContainer/VBoxContainer2/ChatInput.text = ""
	
	rpc("receive_message", msg)

sync func receive_message(msg):
	$HBoxContainer/VBoxContainer2/ChatOutput.text += msg

func _player_connected(id):
	print("_player_connected")
	rpc_id(id, "register_player", my_info)

func _player_disconnected(id):
	print("_player_disconnected")
	player_info.erase(id) # Erase player from info.

func _connected_ok():
	print("_connected_ok")

func _connected_fail():
	print("_connected_fail")

func _server_disconnected():
	print("_server_disconnected")

remote func register_player(info):
	Values.count_player += 1
	print("Registry Player : "+str(info))
	# Get the id of the RPC sender.
	var id = get_tree().get_rpc_sender_id()
	# Store the info
	player_info[id] = info
	
	_color_player()
	$HBoxContainer/VBoxContainer2/ChatOutput.text += "\nNew player ["+str(id)+"] has join game."
	$HBoxContainer/VBoxContainer2/HBoxContainer/Player/ListPlayer.add_item("["+str(id)+"]")

remote func done_preconfiguring():
	var who = get_tree().get_rpc_sender_id()
	# Here are some checks you can do, for example
	assert(get_tree().is_network_server())
	assert(who in player_info) # Exists
	assert(not who in players_done) # Was not added yet

	players_done.append(who)

	if players_done.size() == player_info.size():
		rpc("post_configure_game")

remote func post_configure_game():
	# Only the server is allowed to tell a client to unpause
	if 1 == get_tree().get_rpc_sender_id():
		get_tree().set_pause(false)

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
