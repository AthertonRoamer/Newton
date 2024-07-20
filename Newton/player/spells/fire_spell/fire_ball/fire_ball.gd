class_name FireBall
extends Projectile

@export var collision_shape : CollisionShape2D
@export var explosion_scene : PackedScene
var explosion_damage : int = 50
var max_radius : int = 200
var explosion_knockback : int = 1000
var radius_grow_speed : int = 400


func extinguish() -> void:
	var explosion : Explosion = prep_explosion()
	Main.world.object_holder.call_deferred("add_child", explosion)
	collision_shape.set_deferred("disabled", true)
	visible = false
	$KillTimer.start()
	
	
	
func prep_explosion() -> Explosion:
	var new_explosion : Explosion = explosion_scene.instantiate()
	new_explosion = new_explosion as FireBallExplosion
	new_explosion.global_position = global_position
	new_explosion.damage = explosion_damage
	new_explosion.max_radius = max_radius
	new_explosion.wielder = wielder
	new_explosion.radius_increase_rate = radius_grow_speed
	new_explosion.knockback_force = explosion_knockback
	return new_explosion


func _on_kill_timer_timeout():
	queue_free()
