extends Node3D

@onready
var floor_death_check:Area3D = get_node("FloorDeathCheck")

@export
var lava_tile_scene:PackedScene
@export
var tile_size:float = 10.0

var player_node:Player
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	floor_death_check.body_entered.connect(_on_body_enter_lava)
	pass # Replace with function body.


func _on_body_enter_lava(body:Node3D) -> void:
	if Engine.is_editor_hint():
		return
	print("Lavafied")
	if body is Player:
		get_tree().call_deferred("change_scene_to_packed", load("res://main- real .tscn"))
	elif body as ClimbingPlatform:
		body.call_deferred("queue_free")
	pass

func _physics_process(delta: float) -> void:
	if player_node:
		global_position.x = player_node.global_position.x
		global_position.z = player_node.global_position.z
	else:
		player_node = Globals.player
	
	position.y += delta*0.5
	pass
