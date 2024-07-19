class_name DynamicEnvironmentObject
extends Node2D

var damage_taken : int = 0

func _ready() -> void:
	add_to_group("damageable")
	
	
func take_damage(damage : int, _damage_type : String) -> void:
	damage_taken += damage
	
		
