class_name Goblin
extends HostileEntity

@export var edge_detector : EdgeDetector
@export var obstacle_detector : ObstacleDetector
@export var state_machine : EntityStateMachine

@export var weapon : MeleeWeapon

func _ready() -> void:
	super()
	$StateDisplay.text = str(state_machine.active_state.id)
	state_machine.state_changed.connect(_on_state_changed)
	

func _on_state_changed() -> void:
	$StateDisplay.text = state_machine.active_state.id
	

	

