@tool
extends Node3D
class_name CrossBow


@export
var d_shoot:bool:
	set(value):
		d_shoot = false
		shoot()
@export
var d_reload:bool:
	set(value):
		d_reload = false
		reload()


@onready
var animator:AnimationPlayer = get_node("AnimationPlayer")
@onready
var skeleton:Skeleton3D = get_node("Armature/Skeleton3D")
@onready
var string_bone:int = skeleton.find_bone("String_2")
signal reloaded
signal shot
signal reloading

var loaded:bool = false

var shooting:bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animator.animation_finished.connect(_animation_finished)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_string_pos()->Transform3D:
	return skeleton.global_transform * skeleton.get_bone_global_pose(string_bone)
	


func _animation_finished(anim_name:StringName):
	if anim_name == "Load":
		reloaded.emit()
		loaded = true
		print("Loaded")
	elif anim_name == "Shoot":
		shooting = false
	pass

func reload() -> bool:
	if !visible:
		return false
	if animator.current_animation != "Load" and not loaded:
		reloading.emit()
		animator.play("Load")
		return true
	return false
	

func shoot() -> bool:
	if !visible:
		return false
	if animator.current_animation != "Shoot" and loaded:
		shot.emit()
		loaded = false
		shooting = true
		animator.play("Shoot")
		return true
	return false
	
