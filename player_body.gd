extends CharacterBody3D
class_name Player
@export
var speed:float = 5.0
@export
var jump_velocity:float = 4.5
@export
var turn_speed:float = 5.0
@onready
var hmd: XRCamera3D = get_node("XROrigin/HMD")
@onready
var xr_origin: XROrigin3D = get_node("XROrigin")

@onready
var collider:PlayerCollider = get_node("PlayerCollider")


signal climb_start()
signal climb_stopped()

func _ready() -> void:
	Globals.player = self
	
	global_position -= Vector3(hmd.position.x, position.y, hmd.position.z)
	XRServer.clear_reference_frame()
	XRServer.center_on_hmd(XRServer.DONT_RESET_ROTATION, true)
	pass

func _physics_process(delta: float) -> void:
	var turn_angle: float = turn_input*turn_speed*delta
	
	var delta_pos:Vector3 = global_position - hmd.global_position
	global_position = hmd.global_position + delta_pos.rotated(Vector3.UP, turn_angle)
	
	rotate_y(turn_angle)
	
	
	# Add the gravity.
	if not is_on_floor():
		
		velocity += get_gravity() * delta

	# Handle jump.


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := joystick_dir
	var direction := (hmd.global_basis * Vector3(input_dir.x, 0, input_dir.y))
	if is_on_floor():
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	elif false:
		velocity.x += (direction.x * speed)/(velocity.x + 0.5)
		velocity.z += (direction.z * speed)/(velocity.z + 0.5)

	move_and_slide()


var joystick_dir: Vector2 = Vector2()
func _left_controller_vector2(name: String, value: Vector2) -> void:
	print(name)
	value.y *= -1	
	joystick_dir = value
	
	pass # Replace with function body.

var turn_input: float = 0
func _right_controller_vector2(name: String, value: Vector2) -> void:
	turn_input = value.x*-1
	
	pass # Replace with function body.


func _on_right_button_pressed(name: String) -> void:
	if name == "ax_button" and is_on_floor():
		velocity.y = jump_velocity
		
	pass # Replace with function body.
