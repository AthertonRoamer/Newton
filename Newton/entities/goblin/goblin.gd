class_name Goblin
extends HostileEntity

signal dead() 

@export var weapon : MeleeWeapon

func _ready() -> void:
	super()
	$StateDisplay.text = str(state_machine.active_state.id)
	state_machine.state_changed.connect(_on_state_changed)


func _on_state_changed() -> void:
	$StateDisplay.text = state_machine.active_state.id

func die():
	state_machine.set_state("dead")
	dead.emit()

	
	

