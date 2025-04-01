extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var peer = ENetMultiplayerPeer.new()
	peer.create_client("feien.dev", 55555)
	multiplayer.multiplayer_peer = peer
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
