extends Node3D

func _on_press():
	var xr_interface = XRServer.find_interface("WebXR")
	if xr_interface:
		if xr_interface.is_initialized():
			print("WebXR is initialized successfully.")
			get_viewport().xr_interface = xr_interface
		else:
			print("WebXR interface found but not initialized.")
	else:
		print("WebXR interface not found.")
