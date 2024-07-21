extends EntityState

@export var goal_distance : float = 30

func process_state() -> void:
	if not get_entity().is_player_attackable():
		get_entity().direction = get_entity().get_simple_direction_to_player()
		if not get_entity().is_direction_blocked(get_entity().direction):
			get_entity().walk()
	else:
		if is_instance_valid(Main.player):
			var target_position = Main.player.global_position + (get_entity().invert_direction(get_entity().get_simple_direction_to_player()) * get_entity().sweet_range)
			if get_entity().global_position.distance_to(target_position) <= goal_distance:
				get_entity().direction = get_entity().get_simple_direction_to_player()
			else:
				get_entity().direction = get_entity().get_simple_direction_to(target_position)
				if not get_entity().is_direction_blocked(get_entity().direction):
					get_entity().walk()
	if not get_entity().is_player_nearby():
		state_machine.set_state("patrol")
	elif get_entity().is_player_attackable() and get_entity().can_attack:
		state_machine.set_state("attack")
