extends EntityState

func _on_timer_timeout():
	state_machine.set_state("pursue")
