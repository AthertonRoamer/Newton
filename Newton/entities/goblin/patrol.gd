class_name PatrolState
extends EntityState

func process_state() -> void:
	match get_entity().direction:
		Vector2.RIGHT:
			if get_entity().edge_detector.is_edge_on_right():
				get_entity().direction = Vector2.LEFT
		Vector2.LEFT:
			if get_entity().edge_detector.is_edge_on_left():
				get_entity().direction = Vector2.RIGHT
	get_entity().walk()
	
	
