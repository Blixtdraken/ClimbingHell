@tool
extends XRCamera3D
class_name FakeCamera
var side:int = 0
@onready
var hmd:XRCamera3D = get_node("../../")
@onready
var xr_interface:OpenXRInterface = XRServer.find_interface("OpenXR")
var ipd_mm:float = 63.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	#global_transform = hmd.global_transform
	#global_position += global_basis.x*side* (ipd_mm/2000.0)
	size = hmd.size
	fov = hmd.fov
	projection = hmd.projection
	global_transform = xr_interface.get_transform_for_view(clamp(side,0,1), Transform3D())
	#xr_interface.get_projection_for_view(0, 0, 0, 0).create_frustum()
	
	pass
