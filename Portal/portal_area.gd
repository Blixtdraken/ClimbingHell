@tool
extends Area3D
class_name PortalArea

@onready
var collider:CollisionShape3D = get_node("ColShape")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func is_inside_box_shape(pos:Vector3) -> bool:
	var center = Vector3.ZERO
	var shape_size = (collider.shape as BoxShape3D).size
	var global_scale:Vector3 = global_basis.get_scale()
	var xMinMax:Array = [
		center.x-shape_size.x*global_scale.x/2,
		center.x+shape_size.x*global_scale.x/2]
	var yMinMax:Array = [
		center.y-shape_size.y*global_scale.y/2,
		center.y+shape_size.y*global_scale.y/2,
		]
	var zMinMax:Array = [
		center.z-shape_size.z*global_scale.z/2,
		center.z+shape_size.z*global_scale.z/2,
	]
	var point: Vector3 = collider.global_position - pos
	point = point.rotated(Vector3.RIGHT, -collider.global_rotation.x) #x
	point = point.rotated(Vector3.UP, -collider.global_rotation.y) #y
	point = point.rotated(Vector3.FORWARD, -collider.global_rotation.z) #z
	
	#print(collider.global_rotation_degrees)
	
	if (
		 point.x > xMinMax[0] and point.x < xMinMax[1]
		and point.y > yMinMax[0] and point.y < yMinMax[1]
		and point.z > zMinMax[0] and point.z < zMinMax[1]
	):
		return true
	
	return false
	
