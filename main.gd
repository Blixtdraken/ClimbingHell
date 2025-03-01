extends Node3D
class_name Main
var xr_origin:XROrigin3D


signal focus_lost
signal focus_gained
signal pose_recentered

@export var maximum_refresh_rate : int = 90

var xr_interface : OpenXRInterface
var xr_is_focussed:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	if Globals.score > Globals.high_score:
		Globals.high_score = Globals.score
	Globals.score = 0	
	Globals.main = self
