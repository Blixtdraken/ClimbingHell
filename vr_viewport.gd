extends SubViewport

@export
var side:int = 0

@export
var sizey:float = 0.127
@onready
var hmd:XRCamera3D = get_parent()

@onready
var timer:Timer = Timer.new()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_child(timer)
	timer.one_shot = true
	timer.wait_time = 3
	timer.timeout.connect(_prepare)
	timer.start()
	pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _prepare():
	
	timer.queue_free()
	print("Set up")
	return
	var viewport:Viewport = (get_node("/root") as Window)
	size = viewport.size
	if viewport.use_xr:
		size.x /= 2
	pass # Replace with function body.
	var hmd_dupe:XRCamera3D = hmd.duplicate()
	for child in hmd_dupe.get_children():
		hmd_dupe.remove_child(child)
	hmd_dupe.set_script(preload("res://fake_camera.gd"))
	(hmd_dupe as FakeCamera).side = side
	hmd_dupe.cull_mask -= 131072
	#hmd_dupe.fov = XRServer.get_interface(0).get_projection_for_view(0, 1,hmd_dupe.near, hmd_dupe.far).get_fov()
	
	add_child(hmd_dupe)
	pass
