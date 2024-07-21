class_name LightningExplosion
extends Explosion

@export var lightning_count : int = 5

func _process(delta) -> void:
	if use_built_in_animation:
		radius += radius_increase_rate * .25 * delta
		collision_shape.scale.x = radius / starting_radius
		collision_shape.scale.y = radius / starting_radius
		if radius > max_radius:
			get_parent().queue_free()


func effect_body(body : Node2D) -> void:
	if body.is_in_group("damageable"):
		if is_instance_valid(Main.player):
			body.take_damage(damage, damage_type, Main.player)
		else:
			body.take_damage(damage, damage_type)
	if body.is_in_group("knockable"):
		body.take_knockback(global_position.direction_to(body.global_position) * knockback_force)
