@tool
extends RigidBody3D
class_name Arrow
@onready
var ray_caster:RayCast3D = get_node("arrow/HitCaster")
@onready
var col_shape:CollisionShape3D = get_node("CollisionShape3D")
@onready
var arrow_model:Node3D = get_node("arrow")

var fake_scale:Vector3 = Vector3.ONE:
	set(value):
		fake_scale = value
		col_shape.scale = fake_scale
		arrow_model.scale = fake_scale
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	freeze = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	
	if !freeze:
		ray_caster.force_raycast_update()
		var collider:CollisionObject3D = ray_caster.get_collider()
		if collider:
			if not (collider is Area3D):
				freeze = true
				self.reparent(collider)
				global_position = ray_caster.get_collision_point()
			else:
				queue_free()
func start_arrowing(parent:Node3D = null):
	
	linear_velocity = -global_transform.basis.z*800
	var old_pos:Vector3 = global_position
	var old_rot:Vector3 = global_rotation
	var old_scale:Vector3 = global_basis.get_scale()
	#get_parent().remove_child(self)
	if !parent:
		self.reparent(Globals.main, false)
	else:
		self.reparent(parent, false)
	global_position = old_pos
	global_rotation = old_rot
	fake_scale = old_scale
	freeze = false
	pass
