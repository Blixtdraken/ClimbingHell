extends XROrigin3D

@onready
var hmd: XRCamera3D = get_node("HMD")
# Called every frame. 'delta' is the elapsed time since the previous frame.


func _ready() -> void:
	(get_node("/root/Main") as Main).xr_origin = self
	pass
func _process(delta: float) -> void:
	
	pass
