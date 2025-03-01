extends Label3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	text = "FPS: " + str(int(1/delta)) + "\nPPS: " + str(pps)
	pass

var pps:int = 0

func _physics_process(delta: float) -> void:
	pps = int(1/delta)
	pass
