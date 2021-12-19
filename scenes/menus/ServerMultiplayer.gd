extends Control

onready var peer = NetworkedMultiplayerENet.new()

func _ready():
	_connect_network()
	_info_type_network()
	_connect_signals()

func _connect_network():
	print("[ServerMultiplayer] _ready() | "+str(Values.multi_player_host))
	if Values.multi_player_host == null:
		peer.create_server(Constants.SERVER_PORT, Constants.MAX_PLAYERS)
	else:
		peer.create_client(Values.multi_player_host, Constants.SERVER_PORT)
	get_tree().set_network_peer(peer)

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
	$HBoxContainer/Players/VBoxContainer/ChatInput.text = ""
	
	rpc("receive_message", msg)

sync func receive_message(msg):
	$HBoxContainer/Players/VBoxContainer/ChatOutput.text += msg

func _player_connected():
	print("_player_connected")

func _player_disconnected():
	print("_player_disconnected")

func _connected_ok():
	print("_connected_ok")

func _connected_fail():
	print("_connected_fail")

func _server_disconnected():
	print("_server_disconnected")
