extends Node
class_name Spell

signal available_changed(available : bool)
signal time_till_available_changed(time_till_available : float)
signal selected_changed(selected : bool)

var player : Player


@export var cast_anim_name : String
@export var staff_frame_id : int 
@export var recharge_time : float = 0.0
@export var fire_duration : float = 0.0
@export var menu_data : SpellMenuData
@export var id = "spell"

@export var fire_duration_timer : Timer

@export var select_input_action : StringName
@export var select_input_action_label : String = ""


var charge_time : float = 0
var current_recharge_time : float = 0

@export var vibrate_on_charge : bool = true
@export var base_vibration_distance : float = 0.4 #amount reached after one second of charging
@export var max_vibration_distance : float = 1.0

var selected : bool = false:
	set(v):
		if v != selected:
			selected = v
			selected_changed.emit(selected)

var available : bool = true:
	set(v):
		if v != available:
			available = v
			available_changed.emit(available)
			
var time_till_available : float = 0.0:
	set(v):
		if v != time_till_available:
			time_till_available = v
			time_till_available_changed.emit(time_till_available)

enum state_options {IDLE, CHARGING, FIRING, RECHARGING}
var state : int = state_options.IDLE


func begin_charge() -> void:
	state = state_options.CHARGING
	player.spell_manager.charging_spell_id = id
	

func cast() -> void:
	player.play_cast_anim(cast_anim_name)
	charge_time = 0
	available = false
	if fire_duration != 0.0 and fire_duration_timer != null:
		fire_duration_timer.wait_time = fire_duration
		fire_duration_timer.start()
		state = state_options.FIRING
	else:
		begin_recharge()
	player.spell_manager.charging_spell_id = ""
	if vibrate_on_charge:
		player.set_vibration_distance(0)
		
		
func _on_fire_duration_timer_timeout() -> void:
	begin_recharge()
	
	
func begin_recharge() -> void:
	state = state_options.RECHARGING
	current_recharge_time = 0
	
	
func end_recharge() -> void:
	state = state_options.IDLE
	available = true
	time_till_available = 0
	
	
func _process(delta) -> void:
	match state:
		state_options.CHARGING:
			charge_time += delta
			if vibrate_on_charge:
				var vibration_distance : float = base_vibration_distance * charge_time * charge_time
				vibration_distance = min(vibration_distance, max_vibration_distance)
				player.set_vibration_distance(vibration_distance)
		state_options.RECHARGING:
			current_recharge_time += delta
			if current_recharge_time >= recharge_time:
				end_recharge()
			else:
				time_till_available = recharge_time - current_recharge_time
				
				
func _input(event) -> void:
	if InputMap.has_action(select_input_action):
		if event.is_action_pressed(select_input_action) and not event.is_echo():
			#select self
			player.spell_manager.select_spell_by_num(get_index())
	
	

