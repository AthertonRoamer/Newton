class_name WindBurst
extends Area2D

@export var wind_particle_system : GPUParticles2D
@export var emit_timer : Timer
var enemy_knockback : Vector2 
var wielder : Node2D

var knocking : bool = true

func _ready() -> void:
	for body in get_overlapping_bodies():
		effect_body(body)
	

func _on_emit_timer_timeout():
	wind_particle_system.emitting = false
	$DurationTimer.start()
	knocking = false
	

func _on_duration_timer_timeout():
	queue_free()
	
	
func _on_body_entered(body : Node2D) -> void:
	if knocking:
		effect_body(body)
	
	
func effect_body(body : Node2D) -> void:
	if body != wielder and body.is_in_group("knockable"):
		body.take_knockback(enemy_knockback)
