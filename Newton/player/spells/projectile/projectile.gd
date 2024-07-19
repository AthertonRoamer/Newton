class_name Projectile
extends Area2D

@export var direction : Vector2
@export var speed : float
@export var damage : int
@export var damage_type : String
@export var wielder : Node
@export var extinguish_on_impact : bool
@export var extinguish_on_effect_body : bool
@export var duration_timer : Timer
@export var duration : float = 0
@export var impact_knockback : int = 300

var hit_entities : Array[Node] = []
var velocity : Vector2

func _ready() -> void:
	direction = direction.normalized()
	velocity = direction * speed
	if is_instance_valid(duration_timer) and duration > 0:
		duration_timer.wait_time = duration
		duration_timer.timeout.connect(_on_duration_timer_timeout)
		duration_timer.start()
	body_entered.connect(_on_body_entered)
	for body in get_overlapping_bodies():
		if not hit_entities.has(body) and body != wielder:
			effect_body(body)
		if extinguish_on_impact:
			extinguish()
	
	
func _on_body_entered(body : Node2D) -> void:
	if not hit_entities.has(body) and body != wielder:
		effect_body(body)
	if extinguish_on_impact:
			extinguish()
	
	
func effect_body(body : Node2D) -> void:
	if body.is_in_group("damageable"):
		body.take_damage(damage, damage_type)
		hit_entities.append(body)
	if body.is_in_group("knockable") and impact_knockback > 0:
		body.take_knockback(impact_knockback * velocity.normalized())
	if extinguish_on_effect_body:
		extinguish()


func _process(delta):
	update_position(delta)
	
	
func update_position(delta) -> void:
	position += velocity * delta
	
	
func update_position_with_gravity(delta) -> void:
	velocity.y += PhysicsData.gravity_acceleration
	update_position(delta)
	
	
func extinguish() -> void:
	queue_free()
	
	
func _on_duration_timer_timeout() -> void:
	extinguish()
	
