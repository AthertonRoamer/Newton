extends EntityState

func process_state() -> void:
	get_entity().direction = get_entity().get_simple_direction_to_player()
	var blocked : bool = get_entity().edge_detector.is_edge_in_direction(get_entity().direction)
	blocked = blocked or (get_entity().obstacle_detector.is_obstacle_in_direction(get_entity().direction) and get_entity().obstacle_detector.get_obstacle_type_in_direction(get_entity().direction) != "player")
	if not blocked:
		get_entity().walk()
	#if not get_entity().is_player_nearby():
		#state_machine.set_state("patrol")
	if get_entity().is_player_attackable() and get_entity().can_attack:
		state_machine.set_state("attack")
