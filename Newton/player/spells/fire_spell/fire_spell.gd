class_name FireSpell
extends Spell

@export var projectile_manager : ProjectileHandler
@export var sound : AudioStream
func _ready() -> void:
	projectile_manager.fire_position_node = player.staff_end_node
	
	
func cast() -> void:
	player.screen_shake(.5,2)
	AudioManager.play(sound)
	projectile_manager.fire()
	super()
	
	

