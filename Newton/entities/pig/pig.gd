class_name Pig
extends Entity

var dead : bool = false

func die() -> void:
	if not dead:
		Main.world.level_segment_manager.active_segment.alert_broadcaster.pig_killed.emit(global_position)
		state_machine.set_state("dead")
		dead = true
		$CollisionShape2D.disabled = true
		
		
func take_knockback(knock) -> void:
	if not dead:
		super(knock)


