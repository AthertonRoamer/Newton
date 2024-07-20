class_name SpikePlant
extends Area2D

static var interlude_time : float = 1.0
static var fall_on_spike_damage : int = 10
@export var damage : int = 5
@export var damage_type : String = "spike_plant"
@export var first_damage_type : String = "spike_plant_first"


func damage_body(body : Node2D) -> void:
	if body.is_in_group("damageable"):
		body.take_damage(damage, damage_type)
		
		
func _on_body_entered(body : Node2D) -> void:
	damage_body_first(body)


func _on_strike_timer_timeout():
	for body in get_overlapping_bodies():
		damage_body(body)
		
		
func damage_body_first(body) -> void:
	if body.is_in_group("damageable"):
		body.take_damage(damage, first_damage_type)
