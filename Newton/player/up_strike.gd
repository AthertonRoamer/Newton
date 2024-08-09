extends Sprite2D

@export var y_offset : float = 105
@export var staff_end_node : Node2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#rotation = - get_parent().get_parent().rotation
	global_rotation_degrees = 0
	global_position = staff_end_node.global_position
	global_position.y += y_offset
	
