extends Node



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#IF web export, start webxr instead of openxr
	if OS.has_feature("web"):
		%Button.visible = true
		get_node("WebXR").setup()
		pass
	else:
		%Button.visible = false
		get_node("OpenXR").setup()
		pass
	pass # Replace with function body.
