class_name LevelTestSegmentManager
extends LevelSegmentManager

@export var level_to_test : PackedScene

func _ready() -> void:
	
	if level_to_test != null:
		level_segment_list.append(level_to_test)
	super()
