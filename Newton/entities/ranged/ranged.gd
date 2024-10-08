class_name Ranged
extends HostileEntity


@export var sound : AudioStream
@export var sound2 : AudioStream
signal dead

@export var projectile_handler : RangedProjectileHandler
@export var sweet_range : int = 400

func is_player_attackable() -> bool:
	#AudioManager.play(sound)
	if is_instance_valid(Main.player):
		var to_player : Vector2 = Main.player.global_position - global_position
		return to_player.length() <= attack_range
	else:
		return false
		

func die():
	AudioManager.play(sound)
	dead.emit()
	


func _on_fire_duration_timer_timeout():
	pass # Replace with function body.
