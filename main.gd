extends Node3D
class_name Main
var xr_origin:XROrigin3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Globals.score > Globals.high_score:
		Globals.high_score = Globals.score
	Globals.score = 0	
	Globals.main = self
