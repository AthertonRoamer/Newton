class_name Goblin
extends HostileEntity

signal dead() 

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

func die():
	state_machine.set_state("dead")
	dead.emit()
	
	
func is_direction_blocked(in_direction : Vector2) -> bool:
	var blocked = edge_detector.is_edge_in_direction(in_direction)
	blocked = blocked or obstacle_detector.is_obstacle_in_direction(in_direction)
	return blocked
	
	
func other_direction():
	match direction:
		Vector2.RIGHT:
			return Vector2.LEFT
		Vector2.LEFT:
			return Vector2.RIGHT
