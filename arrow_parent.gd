@tool
extends Node3D


@export 
var cross_bow:CrossBow
@onready
var child = get_node("Child")
@export
var arrow_scene:PackedScene

var current_arrow:Arrow
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cross_bow.shot.connect(_cross_shot)
	cross_bow.reloading.connect(_cross_reload)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	global_transform = cross_bow.get_string_pos()
	
	pass

func _cross_reload():
	print("Reloading Arrow")
	if !current_arrow:
		current_arrow = arrow_scene.instantiate()
		child.add_child(current_arrow)
	pass
func _cross_shot():
	if current_arrow:
		current_arrow.start_arrowing(Globals.main.get_node("Arrows"))
		current_arrow = null
	pass
