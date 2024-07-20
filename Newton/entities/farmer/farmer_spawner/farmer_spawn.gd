class_name FarmerSpawner
extends Node2D

@export var response_range : int = 1000
@export var farmer_scene : PackedScene
	

func _on_pig_died(g_position : Vector2) -> void:
	if global_position.distance_to(g_position) <= response_range:
		spawn_farmer()
		
		
func spawn_farmer() -> void:
	var new_farmer : Farmer = farmer_scene.instantiate()
	new_farmer.global_position = global_position
	Main.world.object_holder.add_child(new_farmer)


func _on_timer_timeout():
	Main.world.level_segment_manager.active_segment.alert_broadcaster.pig_killed.connect(_on_pig_died)
