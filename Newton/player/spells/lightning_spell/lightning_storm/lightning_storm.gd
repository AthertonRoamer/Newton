class_name LightningStorm
extends Node2D

@export var lightning_scene : PackedScene

@export var strike_count : int = 8

@export var min_distance : int = 100
@export var max_distance : int = 500


var lightning_damage : int = 100

func _ready() -> void:
	($Lightning as Lightning).lightning_explosion.damage = lightning_damage


func _on_spawn_lightning_timer_timeout():
	strike_count -= 1
	if strike_count > 0:
		spawn_random_lightning()
	else:
		queue_free()
	
	
func spawn_random_lightning() -> void:
	var distance = randi_range(min_distance, max_distance)
	var offset : Vector2
	if randi() % 2 == 0:
		offset = Vector2.RIGHT * distance
	else:
		offset = Vector2.LEFT * distance

	var lightning : Lightning = lightning_scene.instantiate()
	lightning = lightning as Lightning
	lightning.global_position = global_position + offset
	lightning.lightning_explosion.damage = lightning_damage
	print("internal damage " + str(lightning_damage))
	Main.world.object_holder.add_child(lightning)


