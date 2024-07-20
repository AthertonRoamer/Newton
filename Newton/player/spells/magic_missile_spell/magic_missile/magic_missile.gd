class_name MagicMissile
extends Projectile

func effect_body(body : Node2D) -> void:
	var extinguish_triggered : bool = false
	if body.is_in_group("damageable"):
		if is_instance_valid(wielder):
			body.take_damage(damage, damage_type, wielder)
		else:
			body.take_damage(damage, damage_type)
		hit_entities.append(body)
		extinguish_triggered = true
	if body.is_in_group("knockable") and impact_knockback > 0:
		body.take_knockback(impact_knockback * velocity.normalized())
		extinguish_triggered = true
	if extinguish_on_effect_body and extinguish_triggered:
		extinguish()




