extends CollisionShape3D
class_name PlayerCollider
@onready
var xr_origin: XROrigin3D = get_node("../XROrigin")
@onready
var hmd: XRCamera3D = get_node("../XROrigin/HMD")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



func _physics_process(delta: float) -> void:
	position = Vector3(hmd.position.x, position.y, hmd.position.z)
	
	pass
