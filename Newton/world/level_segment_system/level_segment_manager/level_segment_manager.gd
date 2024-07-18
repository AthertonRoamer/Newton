class_name LevelSegmentManager
extends Node2D

@export var level_segment_list : Array[PackedScene]
var active_segment_scene : PackedScene
var active_segment : LevelSegment

var level_segment_index : int = 0

func _ready() -> void:
	open_level_segment(level_segment_list[0])


func open_level_segment(segment_scene : PackedScene, spawn_state : Player.spawn_states = Player.spawn_states.LOAD_IN) -> void:
	var segment : LevelSegment = segment_scene.instantiate()
	active_segment_scene = segment_scene
	active_segment = segment
	#Main.world.object_holder = active_segment
	add_child(active_segment)
	active_segment.spawn_player(spawn_state)
	
	
func reload_active_segment() -> void:
	active_segment.queue_free()
	open_level_segment(active_segment_scene, Player.spawn_states.LOAD_IN)
	#TODO use correct spawn state
