extends Control

onready var peer = NetworkedMultiplayerENet.new()

func _ready():
	_create_server()

func _create_server():
	peer.create_server(Constants.SERVER_PORT, Constants.MAX_PLAYERS)
	get_tree().network_peer = peer
	
	if get_tree().is_network_server():
		print("Is network server !")
	else:
		print("Is not network server")

func join_server(ip):
	peer.create_client(ip, Constants.SERVER_PORT)
	get_tree().network_peer = peer
