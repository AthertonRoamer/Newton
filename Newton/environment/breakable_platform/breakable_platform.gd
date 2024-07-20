class_name BreakablePlatform
extends StaticBody2D

@export var damage_needed_to_break : int = 15
var broken : bool = false
var damage_taken : int = 0:
	set(v):
		damage_taken = v
		if damage_taken > damage_needed_to_break and not broken:
			call_deferred("break_platform")


func _ready() -> void:
	add_to_group("damageable")
	
	
func take_damage(damage : int, _damage_type : String, _damager : Node = null) -> void:
	damage_taken += damage
	
	
func break_platform() -> void:
	broken = true
	$CollisionShape2D.disabled = true
	#play break animation
	queue_free()
	
	
	
