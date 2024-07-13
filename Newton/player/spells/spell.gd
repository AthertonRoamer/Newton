extends Node
class_name Spell

var player : Player

@export var recharge_time : float = 2.0
@export var fire_duration : float = 0.0
@export var menu_data : SpellMenuData
@export var id = "spell"

@export var fire_duration_timer : Timer

var charge_time : float = 0
var current_recharge_time : float = 0

enum state_options {IDLE, CHARGING, FIRING, RECHARGING}
var state : int = state_options.IDLE


func begin_charge() -> void:
	state = state_options.CHARGING
	
	
func cast() -> void:
	charge_time = 0
	menu_data.available = false
	if fire_duration != 0.0 and fire_duration_timer != null:
		fire_duration_timer.wait_time = fire_duration
		fire_duration_timer.start()
		state = state_options.FIRING
	else:
		begin_recharge()
		
		
func _on_fire_duration_timer_timeout() -> void:
	begin_recharge()
	
	
func begin_recharge() -> void:
	state = state_options.RECHARGING
	current_recharge_time = 0
	
	
func end_recharge() -> void:
	state = state_options.IDLE
	menu_data.available = true
	
	
func _process(delta) -> void:
	match state:
		state_options.CHARGING:
			charge_time += delta
		state_options.RECHARGING:
			current_recharge_time += delta
			if current_recharge_time >= recharge_time:
				end_recharge()
	
	

