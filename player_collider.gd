extends CollisionShape3D
class_name PlayerCollider
@onready
var xr_origin: XROrigin3D = get_node("../XROrigin")
@onready
var hmd: XRCamera3D = get_node("../XROrigin/HMD")

var is_climbing:bool = false

var in_air_mode:bool = false

@onready
var collider_shape:CapsuleShape3D = self.shape

@onready
var default_capsule_height:float = collider_shape.height

@onready
var raycast:RayCast3D = get_node("RayCast3D")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



func _physics_process(delta: float) -> void:
	raycast.enabled = is_climbing
	if is_climbing:
		raycast.target_position.y = -hmd.position.y
		raycast.force_raycast_update()
		position = Vector3(hmd.position.x, hmd.position.y, hmd.position.z)
	else:
		position = Vector3(hmd.position.x, default_capsule_height*0.5, hmd.position.z)
	pass

func set_climbing_mode(is_climbing_value:bool) -> void:
	
	if is_climbing_value:
#		in_air_mode = true
		collider_shape.height = collider_shape.radius*2
	else:
		collider_shape.height = default_capsule_height
	is_climbing = is_climbing_value
	pass
