class_name World
extends Node2D

@export var object_holder : Node
@export var level_segment_manager : LevelSegmentManager


func _ready() -> void:
	Main.world = self
