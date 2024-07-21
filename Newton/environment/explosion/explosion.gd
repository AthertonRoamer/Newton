class_name Explosion
extends Area2D

@export var radius_increase_rate : float = 400 #pixels per second
@export var max_radius : int = 200

@export var damage : float = 50
@export var damage_type : String = "explosion"
@export var knockback_force : float = 1000
@export var collision_shape : CollisionShape2D

@export var use_built_in_animation : bool = true

var starting_radius : float
var radius : float 

func _ready() -> void:
	starting_radius = collision_shape.shape.radius
	radius = starting_radius
	body_entered.connect(_on_body_entered)
	for body in get_overlapping_bodies():
		effect_body(body)
	
	
func effect_body(body : Node2D) -> void:
	if body.is_in_group("damageable"):
		body.take_damage(damage, damage_type)
	if body.is_in_group("knockable"):
		body.take_knockback(global_position.direction_to(body.global_position) * knockback_force)
		
		
func _on_body_entered(body : Node2D) -> void:
	effect_body(body)
	
	
func _process(delta) -> void:
	if use_built_in_animation:
		radius += radius_increase_rate * delta
		collision_shape.scale.x = radius / starting_radius
		collision_shape.scale.y = radius / starting_radius
		
		if radius > max_radius:
			queue_free()
		
