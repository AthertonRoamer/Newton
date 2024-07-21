class_name Goblin
extends HostileEntity


@export var sound : AudioStream
@export var sound2 : AudioStream
signal dead() 

@export var weapon : MeleeWeapon

func _ready() -> void:
	super()
	$StateDisplay.text = str(state_machine.active_state.id)
	state_machine.state_changed.connect(_on_state_changed)


func _on_state_changed() -> void:
	AudioManager.play(sound)
	$StateDisplay.text = state_machine.active_state.id

func die():
	AudioManager.play(sound)
	state_machine.set_state("dead")
	dead.emit()

	
	

