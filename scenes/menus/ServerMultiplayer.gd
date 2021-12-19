extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(Constants.SERVER_PORT, Constants.MAX_PLAYERS)
	get_tree().network_peer = peer
