class_name RangedProjectileHandler
extends ProjectileHandler

signal fire_began
signal fire_ended

@export var ranged : Entity
@export var fire_duration : float = 0.5
@export var fire_duration_timer : Timer
var fire_direction : Vector2

func _ready() -> void:
	fire_duration_timer.wait_time = fire_duration
	

func set_up_projectile() -> Projectile:
	var projectile : Projectile = super()
	projectile.wielder = ranged
	fire_direction = get_projectile_direction()
	projectile.direction = fire_direction
	return projectile
	
	
func fire() -> void:
	super()
	fire_began.emit()
	fire_duration_timer.start()


func _on_fire_duration_timer_timeout():
	fire_ended.emit()
	
	
func get_projectile_direction() -> Vector2:
	var direction : Vector2 = Vector2.RIGHT
	if is_instance_valid(Main.player):
		direction = ranged.global_position.direction_to(Main.player.global_position)
	return direction
