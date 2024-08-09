class_name MagicMissileShooter
extends ProjectileHandler

@export var magic_missile_spell : MagicMissileSpell
var random_angle_range : int = 20

func set_up_projectile() -> Projectile:
	var new_projectile = super()
	var random_angle_offset : float = (randi() % (random_angle_range * 10)) / 10.0
	#print("initial random angle offset: " + str(random_angle_offset))
	random_angle_offset -= float(random_angle_range) / 2.0
	new_projectile.direction = magic_missile_spell.player.staff.cast_direction.rotated(deg_to_rad(random_angle_offset))
	new_projectile.wielder = magic_missile_spell.player
	new_projectile.rotation = magic_missile_spell.player.staff.cast_direction.angle()
	return new_projectile
