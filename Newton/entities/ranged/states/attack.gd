extends EntityState

func _ready() -> void:
	super()
	(get_entity() as Ranged).projectile_handler.fire_ended.connect(_on_fire_ended)
	
	
func activate() -> void:
	super()
	get_entity().direction = get_entity().get_simple_direction_to_player()
	get_entity().projectile_handler.fire()
	
	
func _on_fire_ended() -> void:
	get_entity().register_attack()
	state_machine.set_state("pursue")
	print("attack ended")
