@tool
extends Node3D
class_name Portal
@export
var exit_portal:Portal 


func _ready() -> void:
	get_node("Right/PortalCam").related_portal = exit_portal
	get_node("Left/PortalCam").related_portal = exit_portal
	get_node("Right/PortalCam").sender_portal = self
	get_node("Left/PortalCam").sender_portal = self
	pass
func real_to_exit_transform(real:Transform3D) -> Transform3D:
	# Convert from global space to local space at the entrance (this) portal
	var local:Transform3D = global_transform.affine_inverse() * real
	# Compensate for any scale the entrance portal may have
	var unscaled:Transform3D = local.scaled(global_transform.basis.get_scale())
	# Flip it (the portal always flips the view 180 degrees)
	var flipped:Transform3D = unscaled.rotated(Vector3.UP, PI)
	# Apply any scale the exit portal may have (and apply custom exit scale)
	var exit_scale_vector:Vector3 = exit_portal.global_transform.basis.get_scale()
	var scaled_at_exit:Transform3D = flipped.scaled(Vector3.ONE / exit_scale_vector * (exit_portal.scale/scale))
	# Convert from local space at the exit portal to global space
	var local_at_exit:Transform3D = exit_portal.global_transform * scaled_at_exit
	return local_at_exit
