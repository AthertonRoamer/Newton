class_name FireSpell
extends Spell

@export var projectile_manager : ProjectileHandler

func _ready() -> void:
	projectile_manager.fire_position_node = player.staff_end_node
	
	
func cast() -> void:
	projectile_manager.fire()
	super()
	
	

