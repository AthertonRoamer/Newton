class_name LevelSegment
extends Node2D

@export var spawn_point : Node2D
@export var object_holder : Node2D
var alert_broadcaster : AlertBroadcaster

var player_scene : PackedScene = preload("res://player/player.tscn")

func _ready() -> void:
	alert_broadcaster = AlertBroadcaster.new()
	add_child(alert_broadcaster)
	

func spawn_player(spawn_state : Player.spawn_states):
	var new_player : Player = player_scene.instantiate()
	if is_instance_valid(spawn_point):
		new_player.global_position = spawn_point.global_position
	else:
		push_warning("Level segment " + str(self) + " doesn't have spawn point set")
	new_player.spawn_state = spawn_state
	add_child(new_player)
