class_name World
extends Node2D

@export var object_holder : Node
@export var level_segment_manager : LevelSegmentManager


func _ready() -> void:
	Main.world = self
	if is_instance_valid(level_segment_manager.active_segment):
		object_holder = level_segment_manager.active_segment
