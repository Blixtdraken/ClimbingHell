@tool
extends Camera3D
class_name PortalCamera
@export
var related_portal:Portal
@export
var sender_portal:Portal
@export
var side:Sides = Sides.NULL

enum Sides{
	LEFT=-1,
	RIGHT=1,
	NULL=0
}

func side_to_index(side:Sides) -> int:
	return (side+1)/2

var camera:Camera3D
var cam_transform:Transform3D
var viewport:Viewport

var xr_interface:XRInterface
var xr_origin:XROrigin3D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	if Engine.is_editor_hint():
		#camera = EditorInterface.get_editor_viewport_3d(0).get_camera_3d()
		#viewport = EditorInterface.get_editor_viewport_3d(0)
		#pass
		
		var editor = load("res://Portal/editor.gd")
		editor.run(self)
		print(camera)
	
	else:
		viewport = (get_node("/root") as Window)
		
		if viewport.use_xr:
			
	
			xr_interface = XRServer.primary_interface
			camera = get_node("/root/Main/Player/XROrigin/HMD")
			
			
		else:
			
			camera = viewport.get_camera_3d()
			xr_origin = (get_node("/root/Main") as Main).xr_origin
	pass # Replace with function body.

#@onready
#var xr_interface:OpenXRInterface = (get_node("/root/Main") as Main).xr_interface
#@onready
#var ipd_mm:float = xr_interface.get_transform_for_view(0, Transform3D()).origin.x/2
func change_camera_pos(real_cam:Camera3D):
	#size = real_cam.size
	#fov = real_cam.fov
	#projection = real_cam.projection
	#near = real_cam.near

	global_transform =  sender_portal.real_to_exit_transform(real_cam.global_transform)
	#global_transform.origin += global_basis.x*side*(63.0/2000.0)
	#print("IPD: " + str(4234))
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	change_camera_pos(camera)
	if not Engine.is_editor_hint():
		pass
	var sub_viewport:SubViewport = get_parent()
	xr_interface = XRServer.primary_interface
	sub_viewport.size = get_viewport().size
	if viewport.use_xr:
		sub_viewport.size = xr_interface.get_render_target_size()
		sub_viewport.size.x /= 1
		xr_interface

	print(side_to_index(side))
	if xr_interface:
		var proj: Projection
		proj =  xr_interface.get_projection_for_view(side_to_index(side+1), 1.0, abs(0.1), 10000)
		var tx: Transform3D
		tx = xr_interface.get_transform_for_view(side_to_index(side+1), xr_origin.global_transform)
		var global_transform_ortho := related_portal.global_transform.orthonormalized()
		var p: Vector3 = global_transform_ortho.basis.inverse() * (tx.origin- related_portal.global_transform.origin)
		var my_plane: Plane
		var portal_relative_matrix: Transform3D = Transform3D()
		my_plane = Plane(Vector3(0,0,-1),-2.0 * (global_transform_ortho.affine_inverse() * tx.origin).z)
		proj = oblique_near_plane(tx.affine_inverse() * global_transform_ortho * my_plane, proj)
		proj = proj * Projection(tx.affine_inverse() * global_transform_ortho * portal_relative_matrix * Transform3D(Basis.IDENTITY, p))
		
		
		var my_proj:Projection = xr_interface.get_projection_for_view(side_to_index(side+1), 1.0, abs(0.1), 10000)
		#set("projection", Projection(Transform3D.FLIP_X) * proj *  Projection(Transform3D.FLIP_X))
		set("projection", my_proj)
		
		#set_frustum(related_portal.global_transform.basis.get_scale().y, Vector2(p.x,p.y), abs(p.z), 10000)
		
		
		
		RenderingServer.camera_set_transform(get_camera_rid(), global_transform)
		
		
	
	
	pass
	
func oblique_near_plane(clip_plane: Plane, matrix: Projection) -> Projection:
	# Based on the paper
	# Lengyel, Eric. “Oblique View Frustum Depth Projection and Clipping”.
	# Journal of Game Development, Vol. 1, No. 2 (2005), Charles River Media, pp. 5–16.

	# Calculate the clip-space corner point opposite the clipping plane
	# as (sgn(clipPlane.x), sgn(clipPlane.y), 1, 1) and
	# transform it into camera space by multiplying it
	# by the inverse of the projection matrix
	var q = Vector4(
		(sign(clip_plane.x) + matrix.z.x) / matrix.x.x,
		(sign(clip_plane.y) + matrix.z.y) / matrix.y.y,
		-1.0,
		(1.0 + matrix.z.z) / matrix.w.z)

	var clip_plane4 = Vector4(clip_plane.x, clip_plane.y, clip_plane.z, clip_plane.d)

	# Calculate the scaled plane vector
	var c: Vector4 = clip_plane4 * (2.0 / clip_plane4.dot(q))

	# Replace the third row of the projection matrix
	matrix.x.z = c.x - matrix.x.w
	matrix.y.z = c.y - matrix.y.w
	matrix.z.z = c.z - matrix.z.w
	matrix.w.z = c.w - matrix.w.w
	return matrix
