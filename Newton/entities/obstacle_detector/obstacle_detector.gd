class_name ObstacleDetector
extends Node2D

@export var right_ray_cast : RayCast2D
@export var left_ray_cast : RayCast2D

@export var length : float

func _ready() -> void:
	right_ray_cast.target_position.x = length
	left_ray_cast.target_position.x = -length


func is_obstacle_left() -> bool:
	return left_ray_cast.is_colliding()
	
	
func is_obstacle_right() -> bool:
	return right_ray_cast.is_colliding()
	
	
func is_obstacle_in_direction(direction : Vector2) -> bool:
	match direction:
		Vector2.RIGHT:
			return is_obstacle_right()
		Vector2.LEFT:
			return is_obstacle_left()
		_:
			return false
			
			
func get_obstacle_type_left() -> String:
	if is_obstacle_left():
		if left_ray_cast.get_collider() is Player:
			return "player"
		elif left_ray_cast.get_collider() is Entity:
			return "entity"
		else:
			return "basic"
	else:
		return "none"
	
	
func get_obstacle_type_right() -> String:
	if is_obstacle_right():
		if right_ray_cast.get_collider() is Player:
			return "player"
		elif right_ray_cast.get_collider() is Entity:
			return "entity"
		else:
			return "basic"
	else:
		return "none"
		
		
func get_obstacle_type_in_direction(direction : Vector2) -> String:
	match direction:
		Vector2.RIGHT:
			return get_obstacle_type_right()
		Vector2.LEFT:
			return get_obstacle_type_left()
		_:
			return "none"

