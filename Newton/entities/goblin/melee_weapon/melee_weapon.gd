class_name MeleeWeapon
extends Area2D

signal strike_began
signal strike_ended

@export var timer : Timer
@export var damage : int = 20
@export var damage_type : String = "none"
@export var strike_time : float = 0.75
@export var wielder : Node2D

var striking : bool = false
var entities_hit : Array[Node] = []

func _ready() -> void:
	visible = false
	timer.wait_time = strike_time
	timer.timeout.connect(_on_timer_timeout)
	body_entered.connect(_on_body_entered)


func strike() -> void:
	striking = true
	for body in get_overlapping_bodies():
		effect_body(body)
	timer.start()
	strike_began.emit()
		
		
func end_strike() -> void:
	striking = false
	entities_hit = []
	strike_ended.emit()

	
	
func _on_body_entered(body : Node2D) -> void:
	if striking:
		effect_body(body)
	
	
func effect_body(body : Node2D) -> void:
	if not entities_hit.has(body) and body != wielder:
		if body.is_in_group("damageable"):
			body.take_damage(damage, damage_type)
			entities_hit.append(body)
			
			
func _on_timer_timeout() -> void:
	end_strike()
