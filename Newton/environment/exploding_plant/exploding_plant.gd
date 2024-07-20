class_name ExplodingPlant
extends StaticBody2D

@export var explosion_scene : PackedScene

var damage_taken : int = 0

func _ready() -> void:
	add_to_group("damageable")
	
	
func take_damage(damage : int, _damage_type : String) -> void:
	if damage > 0:
		call_deferred("explode")
		
		
func explode() -> void:
	var explosion : Explosion = explosion_scene.instantiate()
	explosion.global_position = global_position
	Main.world.object_holder.add_child(explosion)
	queue_free()
