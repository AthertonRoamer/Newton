class_name ExplodingPlant
extends StaticBody2D

@export var explosion_scene : PackedScene

var damage_taken : int = 0
var active : bool = true

func _ready() -> void:
	add_to_group("damageable")
	
	
func take_damage(damage : int, _damage_type : String, _damager : Node = null) -> void:
	if damage > 0:
		call_deferred("explode")
		
		
func explode() -> void:
	if active:
		var explosion : Explosion = explosion_scene.instantiate()
		explosion.global_position = global_position
		Main.world.object_holder.add_child(explosion)
		active = false
