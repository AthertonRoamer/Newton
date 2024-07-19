class_name PatrolState
extends EntityState

func process_state() -> void:
	if is_to_far_from_spawn():
		get_entity().direction = get_entity().get_simple_direction_to(get_entity().spawn_position)
		if not get_entity().is_direction_blocked(get_entity().direction):
			get_entity().walk()
			
	else:
		if get_entity().is_direction_blocked(get_entity().direction):
			if not get_entity().is_direction_blocked(get_entity().other_direction()):
				get_entity().switch_direction()
				get_entity().walk()
		else:
			get_entity().walk()
	if get_entity().is_player_nearby():
		state_machine.set_state("pursue")
		
		
func is_to_far_from_spawn() -> bool:
	return get_entity().global_position.distance_to(get_entity().spawn_position) > get_entity().wander_range
		

	
	
