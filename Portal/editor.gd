extends Node


static func run(port_cam:PortalCamera):
	port_cam.camera = EditorInterface.get_editor_viewport_3d(0).get_camera_3d()
	port_cam.viewport = EditorInterface.get_editor_viewport_3d(0)
	print(EditorInterface.get_editor_viewport_3d(0).get_camera_3d())
	print(EditorInterface.get_editor_viewport_3d(0))
	
	pass
