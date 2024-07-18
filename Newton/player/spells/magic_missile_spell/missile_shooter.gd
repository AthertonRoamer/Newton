class_name MagicMissileShooter
extends ProjectileHandler

@export var magic_missile_spell : MagicMissileSpell

func set_up_projectile() -> Projectile:
	var new_projectile = super()
	new_projectile.direction = magic_missile_spell.player.global_position.direction_to(magic_missile_spell.player.get_global_mouse_position())
	return new_projectile
