class_name ProjectileHandler
extends Node

@export var projectile_scene : PackedScene #should extend Projectile
@export var fire_position_node : Node2D

var projectile_direction : Vector2 = Vector2.RIGHT

func set_up_projectile() -> Projectile:
	var new_projectile : Projectile = projectile_scene.instantiate()
	new_projectile.global_position = get_fire_position()
	new_projectile.direction = projectile_direction
	return new_projectile
	
	
func fire() -> void:
	var new_projectile = set_up_projectile()
	Main.world.object_holder.add_child(new_projectile)


func get_fire_position() -> Vector2:
	return fire_position_node.global_position 
