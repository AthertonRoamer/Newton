class_name LevelSegment
extends Node2D

@export var spawn_point : Node2D

var player_scene : PackedScene = preload("res://player/player.tscn")

func spawn_player(spawn_state : Player.spawn_states):
	var new_player : Player = player_scene.instantiate()
	new_player.global_position = spawn_point.global_position
	new_player.spawn_state = spawn_state
	add_child(new_player)
