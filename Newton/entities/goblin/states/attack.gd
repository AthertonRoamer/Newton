class_name StateAttack
extends EntityState

func _ready() -> void:
	super()
	get_entity().weapon.strike_ended.connect(_on_strike_ended)
	
	
func activate() -> void:
	super()
	get_entity().weapon.strike()
	
	
func _on_strike_ended() -> void:
	get_entity().register_attack()
	state_machine.set_state("pursue")
