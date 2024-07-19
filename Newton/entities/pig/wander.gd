extends EntityState

@export var pause_chance : int = 250

func process_state() -> void:
	if get_entity().is_to_far_from_spawn():
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
	if randi_range(0, pause_chance) == 0:
		state_machine.set_state("pause")
