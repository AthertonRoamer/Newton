extends ProjectileHandler

@export var fire_spell : Spell

@export var base_damage : int = 40
@export var max_damage : int = 200

@export var base_radius : float = 300
@export var max_radius : float = 1000

@export var base_grow_speed : int = 800
@export var max_grow_speed : int = 3000

@export var base_explosion_knockback : int = 600
@export var max_exposion_knockback : int = 3000

func set_up_projectile() -> Projectile:
	var p = super()
	p = p as FireBall
	p.wielder = fire_spell.player
	p.direction = get_direction()
	p.explosion_damage = get_damage()
	p.max_radius = get_max_radius()
	p.explosion_knockback = get_explosion_knockback()
	p.radius_grow_speed = get_grow_speed()
	return p
	
	
func get_direction() -> Vector2:
	return fire_spell.player.staff.cast_direction


func get_damage() -> int:
	var charge_time = fire_spell.charge_time
	var d = min(base_damage * charge_time * charge_time, max_damage)
	print("damage: " + str(d))
	return d
	
	
func get_max_radius() -> float:
	var charge_time = fire_spell.charge_time
	var r : float = min(base_radius * charge_time * charge_time, max_radius)
	print("max_r: " + str(r))
	return r
	
	
func get_explosion_knockback() -> int:
	var charge_time = fire_spell.charge_time
	var r : int = min(base_explosion_knockback * charge_time * charge_time, max_exposion_knockback)
	print("knockback: " + str(r))
	return r
	
	
func get_grow_speed() -> int:
	var charge_time = fire_spell.charge_time
	var r : int = min(base_grow_speed * charge_time * charge_time, max_grow_speed)
	print("grow_speed " + str(r))
	return r
