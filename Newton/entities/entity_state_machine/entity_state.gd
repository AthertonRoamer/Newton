class_name EntityState
extends Node

@export var id : String = "state"
@export var first_active_state : bool = false

var state_machine : EntityStateMachine
var active : bool = false

func _ready() -> void:
	if get_parent() is EntityStateMachine:
		state_machine = get_parent()
		state_machine.register_new_state(self)
	else:
		push_warning("EntityState should be a child of an EntityStateMachine")


func activate() -> void:
	active = true


func deactivate() -> void:
	active = false


func process_state() -> void:
	pass
	
	
func get_entity() -> Entity:
	return state_machine.entity
