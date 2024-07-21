class_name HostileEntity
extends Entity

@export var sight_range : int = 300
@export var attack_range : int = 60
@export var attack_delay : float = 0.5
@export var attack_angle_range_above : float = 45
@export var attack_angle_range_below : float = 45

var can_attack : bool = true
@export var can_attack_timer : Timer




func _ready() -> void:
	super()
	if can_attack_timer != null:
		can_attack_timer.wait_time = attack_delay
		can_attack_timer.one_shot = true
		can_attack_timer.timeout.connect(_on_can_attack_timer_timeout)


func is_player_nearby() -> bool:
	if is_instance_valid(Main.player):
		return global_position.distance_to(Main.player.global_position) < sight_range
	else:
		return false
		
	
func is_player_attackable() -> bool:
	if is_instance_valid(Main.player):
		var to_player : Vector2 = Main.player.global_position - global_position
		if to_player.length() <= attack_range:
			if sign(to_player.y) == 1: #player above entity
				return to_player.angle_to(direction) <= attack_angle_range_above
			else: #player below entity
				return to_player.angle_to(direction) <= attack_angle_range_below
		else:
			return false
	else:
		return false
	
	
func get_simple_direction_to_player() -> Vector2:
	if is_instance_valid(Main.player) and global_position.x > Main.player.global_position.x:
		return Vector2.LEFT
	else:
		return Vector2.RIGHT


func register_attack() -> void:
	if is_instance_valid(can_attack_timer):
		can_attack = false
		can_attack_timer.start()
		

func _on_can_attack_timer_timeout() -> void:
	can_attack = true
	print("wowo")
