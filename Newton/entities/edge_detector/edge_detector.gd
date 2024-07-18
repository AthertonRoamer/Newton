class_name EdgeDetector
extends Node2D

@export var width : float = 32
@export var length : float = 50
@export var right_ray : RayCast2D
@export var left_ray : RayCast2D


func _ready() -> void:
	right_ray.target_position.y = length
	left_ray.target_position.y = length
	right_ray.position.x = width / 2
	left_ray.position.x = -width / 2
	
	
func is_edge_on_right() -> bool:
	return not right_ray.is_colliding()
	
	
func is_edge_on_left() -> bool:
	return not left_ray.is_colliding()
	
	
func is_edge_in_direction(direction : Vector2) -> bool:
	if direction == Vector2.RIGHT:
		return is_edge_on_right()
	elif direction == Vector2.LEFT:
		return is_edge_on_left()
	else:
		return false

