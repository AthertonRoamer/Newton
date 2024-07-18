class_name PatrolState
extends EntityState

func process_state() -> void:
	if get_entity().edge_detector.is_edge_in_direction(get_entity().direction) or get_entity().obstacle_detector.is_obstacle_in_direction(get_entity().direction):
		get_entity().switch_direction()
	get_entity().walk()
	if get_entity().is_player_nearby():
		state_machine.set_state("pursue")

	
	
