extends Control

onready var peer = NetworkedMultiplayerENet.new()

func _ready():
	print("[ServerMultiplayer] _ready() | "+str(Values.multi_player_host))
	if Values.multi_player_host == null:
		_create_server()
	else:
		_join_server()
	
	if get_tree().is_network_server():
		print("Is network server !")
	else:
		print("Is not network server")

func _create_server():
	print("Create Server")
	peer.create_server(Constants.SERVER_PORT, Constants.MAX_PLAYERS)
	get_tree().network_peer = peer

func _join_server():
	print("Join Server")
	peer.create_client(Values.multi_player_host, Constants.SERVER_PORT)
	get_tree().network_peer = peer
