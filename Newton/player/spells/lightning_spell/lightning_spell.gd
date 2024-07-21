class_name LightningSpell
extends Spell

@export var lightning_scene : PackedScene
@export var lightning_storm_scene : PackedScene 

@export var base_damage : float = 50
@export var max_damage : float = 200
@export var min_damage : float = 10

@export var base_strike_count : int = 3
@export var max_strike_count : int = 10


func cast() -> void:
	spawn_lightning()
	super()


func spawn_lightning() -> void:
	var damage : int = max(min(base_damage * charge_time * charge_time, max_damage), min_damage)
	var strike_count : int = min(round(base_strike_count * charge_time * charge_time), max_strike_count)
	print("lightning damage: " + str(damage))
	
	var storm : LightningStorm = lightning_storm_scene.instantiate()
	storm = storm as LightningStorm
	storm.global_position = player.get_global_mouse_position()
	storm.lightning_damage = damage
	storm.strike_count = strike_count
	Main.world.object_holder.add_child(storm)