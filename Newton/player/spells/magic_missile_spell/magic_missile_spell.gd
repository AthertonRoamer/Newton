class_name MagicMissileSpell
extends Spell

@export var missile_shooter : MagicMissileShooter

func _ready() -> void:
	missile_shooter.fire_position_node = player.staff_end_node
	
	
func cast() -> void:
	missile_shooter.fire()
	super()
