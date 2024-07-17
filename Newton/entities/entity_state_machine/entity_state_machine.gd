class_name EntityStateMachine
extends Node

signal state_changed

@export var active : bool = true 
@export var entity : Entity

var initial_state_id : String = ""
var active_state : EntityState

var states : Dictionary = {}
#form::  key: state_id (String), value: state (EntityState)


func _ready() -> void:
	if not is_instance_valid(entity):
		push_warning("EntityStateMachine does not have an Entity")
		active = false
	if states.is_empty():
		push_warning("EntityStateMachine has no states")
		active = false
	if is_instance_valid(active_state):
		active_state.activate()
	else:
		push_warning("EntityStateMachine has no initial state")
		active = false


func register_new_state(new_state : EntityState) -> void:
	if states.keys().has(new_state.id):
		push_warning("Entity state \"" + new_state.id + "\" not registered because another state with the same id is already registered") 
	else:
		states[new_state.id] = new_state
		if new_state.first_active_state:
			if initial_state_id == "":
				initial_state_id = new_state.id
				active_state = new_state
			else:
				push_warning("Entity states \"" + initial_state_id + "\" and \"" + new_state.id + "\" both claim to be first active state. Keeping \"" + active_state.id + "\"")


func set_state(state_id : String = initial_state_id) -> void: #sets state from a state id (String)
	if state_id != "" and states.has(state_id):
		if state_id != active_state.id:
			active_state.deactivate()
			active_state = states[state_id]
			active_state.activate()
			state_changed.emit()
	else:
		push_warning("Attempted to set state to invalid state id: \"" + state_id + "\"")


func _process(_delta) -> void:
	if active:
		active_state.process_state()
