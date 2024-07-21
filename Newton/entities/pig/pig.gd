class_name Pig
extends Entity

signal deaded
var dead : bool = false

func die() -> void:
	if not dead:
		Main.world.level_segment_manager.active_segment.alert_broadcaster.pig_killed.emit(global_position)
		state_machine.set_state("dead")
		dead = true
		#$CollisionShape2D.disabled = true
		deaded.emit()
		#queue_free()
		#TODO instance pig corpse
		
		
func take_knockback(knock) -> void:
	if not dead:
		super(knock)
		
		
func take_damage(damage : int, _damage_type : String = "none", damager : Node = null) -> void:
	if not dead:
		if damager is Player:
			super(damage)


