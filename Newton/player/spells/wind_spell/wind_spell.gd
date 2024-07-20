class_name WindSpell
extends Spell

@export var wind_burst_scene : PackedScene
@export var base_player_force : float = 2000
@export var max_player_force : float = 1350

@export var base_particle_count : int = 3000
@export var max_particle_count : int = 10000

@export var base_emit_duration : float = 0.9
@export var max_emit_duration : float = 1.2

@export var base_enemy_knockback : float = 2000
@export var max_enemy_knockback : float = 1350


func cast() -> void:
	var real_player_force = base_player_force * charge_time * charge_time
	var cast_direction : Vector2 = player.staff.cast_direction
	var knock_back_direction : Vector2 = cast_direction * -1
	real_player_force = min(real_player_force, max_player_force)
	player.take_knockback(real_player_force * knock_back_direction)
	var wind_burst : WindBurst = prep_wind_burst()
	player.wind_burst_holder.add_child(wind_burst)
	super()


func prep_wind_burst() -> WindBurst:
	var cast_direction : Vector2 = player.staff.cast_direction
	cast_direction = cast_direction.normalized()
	var wind_burst : WindBurst = wind_burst_scene.instantiate()
	wind_burst.look_at(wind_burst.global_position + cast_direction)
	
	wind_burst.wind_particle_system.amount = min(round(base_particle_count * charge_time * charge_time), max_particle_count)
	
	#wind_burst.wind_particle_system.process_material.direction = Vector3(cast_direction.x, cast_direction.y, 0)
	
	var enemy_knockback_force : int = round(min(base_enemy_knockback * charge_time * charge_time, max_enemy_knockback))
	wind_burst.enemy_knockback = cast_direction * enemy_knockback_force
	
	var emit_duration : float = min(base_emit_duration * charge_time * charge_time, max_emit_duration)
	wind_burst.emit_timer.wait_time = emit_duration
	
	wind_burst.wielder = player
	
	return wind_burst
