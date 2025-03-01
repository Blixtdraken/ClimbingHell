@tool
extends Node3D
class_name Claw

@onready
var animator:AnimationPlayer = get_node("AnimationPlayer")

@onready
var claw_follow:Node3D = get_parent().get_node("ClawFollow")

@export_range(0.0,1.0,0.01)
var state: float:
	set(value):
		set_open_float(value)
		state = value

@export
var paused:bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animator.play("ArmatureAction_001", -1, 0.0)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !paused:
		set_transform_from_node3d(claw_follow)
	pass

enum ClawState {OPEN,
CLOSED}

func set_transform_from_node3d(node:Node3D) -> void:
	global_position = node.global_position
	global_rotation_degrees = node.global_rotation_degrees
	pass

func set_open_float(value:float) -> void:
	if animator:
		animator.seek(animator.current_animation_length*value, true, true)
	
	pass
