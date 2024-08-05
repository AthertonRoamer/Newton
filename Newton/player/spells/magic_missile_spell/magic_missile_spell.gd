class_name MagicMissileSpell
extends Spell

@export var sound : AudioStream
@export var missile_shooter : MagicMissileShooter
@export var starting_fire_wait_time : float = 0.2
@export var fire_wait_time_deaccel : float = 0.005
@export var min_fire_wait_time : float = 0.07
@export var safe_time : float = 3.0
@export var damage_wait_time : float = 0.2
@export var fire_timer : Timer
@export var damage_player_timer : Timer

@export var damage_per_wait_time : int = 10
@export var damage_type : String = "magic_overload"

var damaging_player : bool = false

func _ready() -> void:
	fire_timer.wait_time = starting_fire_wait_time
	damage_player_timer.wait_time = damage_wait_time
	missile_shooter.fire_position_node = player.staff_end_node
	
	
func begin_charge() -> void:
	super()
	fire_timer.start()
	
	
func cast() -> void:
	super()
	fire_timer.stop()
	fire_timer.wait_time = starting_fire_wait_time
	damage_player_timer.stop()
	damaging_player = false


func _on_fire_timer_timeout():
	player.screen_shake(.25,1)
	if not player.dead:
		missile_shooter.fire()
	fire_timer.wait_time -= fire_wait_time_deaccel
	if fire_timer.wait_time < min_fire_wait_time:
		fire_timer.wait_time = min_fire_wait_time
	
	
func _process(delta):
	super(delta)
	if charge_time > 3.0 and not damaging_player:
		damaging_player = true
		player.take_damage(damage_per_wait_time, damage_type)
		damage_player_timer.start()


func _on_damage_player_timer_timeout():
	player.take_damage(damage_per_wait_time, damage_type)
