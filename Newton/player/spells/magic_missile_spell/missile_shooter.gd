class_name MagicMissileShooter
extends ProjectileHandler

@export var magic_missile_spell : MagicMissileSpell

func set_up_projectile() -> Projectile:
	var new_projectile = super()
	new_projectile.direction = magic_missile_spell.player.staff.cast_direction
	new_projectile.wielder = magic_missile_spell.player
	return new_projectile
