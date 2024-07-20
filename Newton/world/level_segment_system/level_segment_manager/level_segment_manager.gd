class_name LevelSegmentManager
extends Node2D

@export var level_segment_list : Array[PackedScene]
var active_segment_scene : PackedScene
var active_segment : LevelSegment

var level_segment_index : int = 0

func _ready() -> void:
	if level_segment_list.size() >= 1 and level_segment_list[0] != null and level_segment_list[0].can_instantiate():
		open_level_segment(level_segment_list[0])
	else:
		push_warning("Level Segment Manager has no Level Segments")


func open_level_segment(segment_scene : PackedScene, spawn_state : Player.spawn_states = Player.spawn_states.LOAD_IN) -> void:
	var segment : LevelSegment = segment_scene.instantiate()
	active_segment_scene = segment_scene
	active_segment = segment
	if is_instance_valid(Main.world):
		if is_instance_valid(active_segment.object_holder):
			Main.world.object_holder = active_segment.object_holder
		else:
			Main.world.object_holder = active_segment
	add_child(active_segment)
	active_segment.spawn_player(spawn_state)
	
	
func close_active_segment() -> void:
	active_segment.queue_free()
	
	
func reload_active_segment(spawn_state : Player.spawn_states = Player.spawn_states.RESPAWN) -> void:
	close_active_segment()
	open_level_segment(active_segment_scene, spawn_state)
	
	
func transfer_to_next_segment() -> void:
	level_segment_index += 1
	if level_segment_list.size() >= level_segment_index + 1 and level_segment_list[level_segment_index] != null and level_segment_list[level_segment_index].can_instantiate():
		close_active_segment()
		open_level_segment(level_segment_list[level_segment_index], Player.spawn_states.LEVEL_TRANSFER)
	else:
		if is_instance_valid(Main.main):
			close_active_segment()
			Main.main.exit_game_to_menu()
		else:
			push_warning("No level segment to load")
			
			
func load_level_segment_by_index(level_num : int, spawn_state : Player.spawn_states = Player.spawn_states.TOTAL_RESPAWN) -> void:
	if level_segment_list.size() >= level_num + 1 and level_segment_list[level_num] != null and level_segment_list[level_num].can_instantiate():
		level_segment_index = level_num
		close_active_segment()
		open_level_segment(level_segment_list[level_segment_index], spawn_state)
	else:
		push_warning("Level segment manager given invalid level index to switch to")
		
	
