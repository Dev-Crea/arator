extends Node

# warning-ignore:unused_signal
signal message(canal)

onready var peer = NetworkedMultiplayerENet.new()
var internet = false

# Player info, associate ID to data
var player_info = {}
# Info we send to other players
var my_info = {}
# Info about user ready to play (used only when waiting connection)
var players_done = []

func _ready():
	print("Connection module is ready")
	check_internet()

func configure(node_name, commander_info):
	_configure_type_network(node_name, commander_info)
	_connect_signals()

func check_internet():
	print("Check internet connectivity")
	var http = HTTPRequest.new()
	
	add_child(http)
	
	http.connect("request_completed", self, "_on_request_completed")
	http.request("https://duckduckgo.com/")

func _configure_type_network(node_name, commander_info):
	if Values.multi_player_host == null:
		_configure_server()
	else:
		_configure_client()
	
	get_tree().set_network_peer(peer)
	_pre_configure_game(node_name, commander_info)

func _configure_server():
	peer.create_server(Constants.SERVER_PORT, Constants.MAX_PLAYERS)

func _configure_client():
	peer.create_client(Values.multi_player_host, Constants.SERVER_PORT)

func _connect_signals():
	alert_signal(get_tree().connect("network_peer_connected", self, "_player_connected"), "network_peer_connected")
	alert_signal(get_tree().connect("network_peer_disconnected", self, "_player_disconnected"), "network_peer_disconnected")
	alert_signal(get_tree().connect("connected_to_server", self, "_connected_ok"), "connected_to_server")
	alert_signal(get_tree().connect("connection_failed", self, "_connected_fail"), "connection_failed")
	alert_signal(get_tree().connect("server_disconnected", self, "_server_disconnected"), "server_disconnected")

func alert_signal(signal_connect, signal_name):
	if !signal_connect:
		print("Error when "+signal_name)

remote func _pre_configure_game(node_name, commander_info):
	var selfPeerID = get_tree().get_network_unique_id()
	var node = "/root/" + node_name + "/Players"
	
	# Load my player
	var my_player = preload("res://scenes/players/Commander.tscn").instance()
	my_player.set_pseudo(commander_info["pseudo"])
	my_player.set_name(str(selfPeerID))
	my_player.set_network_master(selfPeerID) # Will be explained later
	#get_node(node).add_child(my_player)

	# Load other players
	for info in player_info:
		var player = preload("res://scenes/players/Player.tscn").instance()
		player.set_pseudo(info["pseudo"])
		player.set_name(str(info))
		player.set_network_master(info) # Will be explained later
		get_node(node).add_child(player)
	
	if is_instance_valid(Values.multi_player_host):
		# Tell server (remember, server is always ID=1) that this peer is done pre-configuring.
		# The server can call get_tree().get_rpc_sender_id() to find out who said they were done.
		rpc_id(1, "done_preconfiguring")

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
	print("Registry Player : "+str(info))
	Values.count_player += 1
	print("Number of player : "+str(Values.count_player))
	# Get the id of the RPC sender.
	var id = get_tree().get_rpc_sender_id()
	# Store the info
	player_info[id] = info

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

func _on_request_completed(result, response_code, _headers, _body):
	print("_on_request_completed - "+str(response_code)+" -- "+str(result))
	if result != HTTPRequest.RESULT_SUCCESS:
		print("No internet connection")
		internet = true
	else:
		internet = false
