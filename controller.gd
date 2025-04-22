extends XRController3D

class_name Controller
@onready
var grabber_area: Area3D = get_node("GrabberArea")
@onready
var claw_model: Claw = get_node("Claw")
var climb_pivot:Variant = null
@onready
var player: Player = get_parent().get_parent()

@export
var other_controller:Controller


@onready
var cross_bow:CrossBow = get_node_or_null("crosssbow")

var controller_velocity:Vector3 = Vector3()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	input_float_changed.connect(_float_changed)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
var prev_controller_pos:Vector3 = Vector3()

func _process(delta: float) -> void:
	controller_velocity = (prev_controller_pos-position)/delta
	prev_controller_pos = position

func _physics_process(delta: float) -> void:

	
	if is_climbing:
		
		if not climb_pivot:
			
			for body in grabber_area.get_overlapping_bodies():
					if body is ClimbingPlatform or body.has_meta("climbable"):
						body = body as ClimbingPlatform
						if not climb_pivot and not other_controller.climb_pivot:
							player.climb_start.emit()
						climb_pivot = global_position
						claw_model.paused = true
						claw_model.set_transform_from_node3d(claw_model.claw_follow)
						body._on_climb_grab()
						other_controller.release_clamp()
						
						break
		else:
			player.global_position += climb_pivot-global_position
			player.velocity = controller_velocity.rotated(Vector3.UP, player.rotation.y)
			
		
	pass


var is_climbing: bool = false

func release_clamp():
	is_climbing = false
	claw_model.paused = false
	pass

var last_trigger_float:float = 0
func _float_changed(name: String, value: float) -> void:
	
	if name == "trigger":
		claw_model.state = 1.0 - value
		if value == 0:
			if climb_pivot and not other_controller.climb_pivot:
				player.climb_stopped.emit()
			is_climbing = false
			climb_pivot = null
			claw_model.paused = false
			
		elif value > last_trigger_float and !climb_pivot:
			is_climbing = true
		
	elif cross_bow and name == "grip":
		if value == 1.0:
			if cross_bow.loaded:
				cross_bow.shoot()
			else:
				cross_bow.reload()
	pass # Replace with function body.
	
