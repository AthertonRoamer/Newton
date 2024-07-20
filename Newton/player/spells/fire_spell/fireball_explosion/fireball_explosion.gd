class_name FireBallExplosion
extends Explosion

var wielder : Player

func _process(delta):
	super(delta)
	if use_built_in_animation:
		$Sprite2D.scale.x = radius / starting_radius
		$Sprite2D.scale.y = radius / starting_radius


func effect_body(body : Node2D) -> void:
	if body.is_in_group("damageable"):
		if is_instance_valid(wielder):
			body.take_damage(damage, damage_type, wielder)
		else:
			body.take_damage(damage, damage_type)
	if body.is_in_group("knockable"):
		body.take_knockback(global_position.direction_to(body.global_position) * knockback_force)
