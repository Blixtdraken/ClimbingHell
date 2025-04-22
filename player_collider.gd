extends CollisionShape3D
class_name PlayerCollider
@onready
var xr_origin: XROrigin3D = get_node("../XROrigin")
@onready
var hmd: XRCamera3D = get_node("../XROrigin/HMD")
@onready
var player:Player = xr_origin.get_parent()


var climbing_mode:bool = false
var is_climbing:bool = false
var in_air_mode:bool = false

@onready
var collider_shape:CapsuleShape3D = self.shape

@onready
var default_capsule_height:float = collider_shape.height

@onready
var raycast:RayCast3D = get_node("FloorRay")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.climb_start.connect(_on_climb)
	player.climb_stopped.connect(_on_stop_climb)
	pass # Replace with function body.


var speed_to_seddle:float = 3
func _physics_process(delta: float) -> void:
	
	raycast.enabled = climbing_mode
	if climbing_mode:
		if !is_climbing && (player.velocity*Vector3(1,0,1)).length() < speed_to_seddle:
			raycast.target_position.y = -hmd.position.y
			raycast.force_raycast_update()
			if raycast.is_colliding():
				var hit_pos:Vector3 = raycast.get_collision_point()
				player.position.y = hit_pos.y
				set_climbing_mode(false)
		position = Vector3(hmd.position.x, hmd.position.y, hmd.position.z)
	else:
		position = Vector3(hmd.position.x, default_capsule_height*0.5, hmd.position.z)
	pass

func _on_climb():
	print("start climb")
	set_climbing_mode(true)
	is_climbing = true
	
	pass
func _on_stop_climb():
	print("Stopped Climb")
	is_climbing = false
	pass

func set_climbing_mode(is_climbing_value:bool) -> void:
	
	if is_climbing_value:
#		in_air_mode = true
		collider_shape.height = collider_shape.radius*2
	else:
		collider_shape.height = default_capsule_height
	climbing_mode = is_climbing_value
	pass
