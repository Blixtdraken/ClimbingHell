extends Node3D

@onready
var enter_area: PortalArea = get_node("Enter")
@onready
var exit_area: PortalArea = get_node("Exit")

@export
var current_portal: Portal
@export
var other_portal: Portal
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var prev_bodies:Array[Node3D]
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for body in prev_bodies:
		if exit_area.is_inside_box_shape(body.position):
			teleport_node(body)
	
	prev_bodies.clear()
	for body in enter_area.get_overlapping_bodies():
		
		if enter_area.is_inside_box_shape(body.global_position):
			prev_bodies.append(body)
	pass
	
func teleport_node(node:Node3D):
	
	
	node.global_transform = current_portal.real_to_exit_transform(node.global_transform)
	if node is CharacterBody3D:
		(node as CharacterBody3D).velocity *= other_portal.scale/current_portal.scale
	pass
	
