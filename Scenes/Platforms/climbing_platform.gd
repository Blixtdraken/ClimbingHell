class_name ClimbingPlatform
extends StaticBody3D

var prev_platform:ClimbingPlatform
var next_platform:ClimbingPlatform

@export
var spawn_platform_setttings:PlatformSpawnSettings

var platform_count:int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func _on_climb_grab():
	if Globals.score < platform_count:
		Globals.score = platform_count
	
	var current_platform = self
	for i in range(5):
		current_platform = current_platform.get_or_generate_next_platform()
	pass


func get_or_generate_next_platform() -> ClimbingPlatform:
	if !next_platform:
		var spawn_offset = rand_range_vector3(spawn_platform_setttings.spawn_ranges.offset_min, spawn_platform_setttings.spawn_ranges.offset_max)
		var packed_scene:PackedScene = preload("res://Scenes/Platforms/real-platform.tscn")
		var platform:ClimbingPlatform = packed_scene.instantiate()
		next_platform = platform
		platform.prev_platform = self
		platform.position = position + spawn_offset
		platform.platform_count = platform_count + 1
		get_parent().add_child(platform)
		
	return next_platform

func rand_range_vector3(min:Vector3, max:Vector3)->Vector3:
	
	var x = randf_range(min.x, max.x)
	var y = randf_range(min.y, max.y)
	var z = randf_range(min.z, max.z)
	return Vector3(x,y,z)
	
