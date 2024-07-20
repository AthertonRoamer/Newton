class_name Entity
extends CharacterBody2D

signal health_changed(new_health : int)
signal direction_changed(new_direction : Vector2)
signal walking_changed(new_walking : bool) 

@export var max_health : int = 100
@export var starting_health : int = 100

@export var gravity_acceleration : int = PhysicsData.gravity_acceleration
@export var death_altitude : int = PhysicsData.death_altitude

@export var walk_accel : int = 80
@export var friction : int = 30
@export var max_walk_speed : int = 350
@export var wander_range : int = 700

@export var edge_detector : EdgeDetector
@export var obstacle_detector : ObstacleDetector

@export var state_machine : EntityStateMachine

var direction : Vector2 = Vector2.RIGHT:
	set(v):
		if v != direction:
			direction = v 
			direction_changed.emit(direction)

var walking : bool = false
var was_walking_last_frame : bool = false

var health : int = starting_health:
	set(v):
		if v != health:
			health_changed.emit(v)
		health = v
		if health <= 0:
			health = 0
			call_deferred("die")

var spawn_position : Vector2

var immune_to_spike : bool = false
var immune_to_spike_timer : Timer

func _ready() -> void:
	set_up_immune_to_spike_timer()
	health = starting_health
	spawn_position = global_position
	add_to_group("damageable")
	add_to_group("knockable")
	
	
func set_up_immune_to_spike_timer() -> void:
	immune_to_spike_timer = Timer.new()
	immune_to_spike_timer.wait_time = SpikePlant.interlude_time
	immune_to_spike_timer.one_shot = true
	add_child(immune_to_spike_timer)


func take_damage(damage : int, damage_type : String = "none") -> void:
	if damage_type == "spike_plant_first":
		if not is_on_floor() and velocity.y > 0:
			health -= SpikePlant.fall_on_spike_damage
		else:
			health -= damage
		immune_to_spike = true
		immune_to_spike_timer.start()
	elif damage_type == "spike_plant":
		if not immune_to_spike:
			health -= damage
			immune_to_spike = true
			immune_to_spike_timer.start()
	else:
		health -= damage


func take_knockback(knock : Vector2) -> void:
	velocity += knock


func die() -> void:
	queue_free()
	
	
func switch_direction() -> void:
	match direction:
		Vector2.RIGHT:
			direction = Vector2.LEFT
		Vector2.LEFT:
			direction = Vector2.RIGHT


func walk() -> void:
	if not walking:
		walking = true
		if not was_walking_last_frame:
			walking_changed.emit(true)


func process_walking() -> void:
	var lateral_acceleration : int = 0
	if walking:
		match direction:
			Vector2.RIGHT:
				lateral_acceleration += walk_accel
			Vector2.LEFT:
				lateral_acceleration += -walk_accel
		
		#apply max speed
		if abs(velocity.x + lateral_acceleration) < max_walk_speed:
			velocity.x += lateral_acceleration
		
		walking = false
		was_walking_last_frame = true
	else:
		if was_walking_last_frame:
			walking_changed.emit(false)
		was_walking_last_frame = false


func basic_entiy_friction() -> void:
	
	#apply friction
	var velocity_sign : int = sign(velocity.x)
	var pos_v : float = abs(velocity.x)
	if is_on_floor():
		pos_v -= friction
	pos_v = max(0, pos_v)
	velocity.x = velocity_sign * pos_v


func basic_entity_gravity() -> void:
	if is_on_floor() and velocity.y > 0:
		velocity.y = 0
	else:
		velocity.y += gravity_acceleration
	if position.y > death_altitude:
		health = 0


func basic_entity_physics() -> void:
	basic_entiy_friction()
	basic_entity_gravity()


func _physics_process(_delta) -> void:
	process_walking()
	basic_entity_physics()
	move_and_slide()
	
	
func get_simple_direction_to(other_global_position : Vector2) -> Vector2:
	if global_position.x > other_global_position.x:
		return Vector2.LEFT
	else:
		return Vector2.RIGHT
		
		
func other_direction():
	match direction:
		Vector2.RIGHT:
			return Vector2.LEFT
		Vector2.LEFT:
			return Vector2.RIGHT
			
			
func is_direction_blocked(in_direction : Vector2) -> bool:
	var blocked : bool = false
	if is_instance_valid(edge_detector):
		blocked = edge_detector.is_edge_in_direction(in_direction)
	if is_instance_valid(obstacle_detector):
		blocked = blocked or obstacle_detector.is_obstacle_in_direction(in_direction)
	return blocked
	
	
func is_to_far_from_spawn() -> bool:
	return global_position.distance_to(spawn_position) > wander_range
	
	
func immune_to_spike_timer_timeout() -> void:
	immune_to_spike = false
	
