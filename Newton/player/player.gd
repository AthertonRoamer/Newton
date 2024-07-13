class_name Player
extends CharacterBody2D

@export var walk_accel : int = 40
@export var friction : int = 25
@export var max_walk_speed : int = 250
@export var max_sprint_speed : int = 350
var effective_max_speed : int

@export var jump_accel : int = 700
@export var gravity : int = 35

@export var death_altitude : int = 3000

var direction : Vector2 = Vector2.RIGHT

var max_health : int = 100
var health : int = max_health:
	set(v):
		health = v
		if health < 0:
			die()

@export var spell_manager : SpellManager

func reset() -> void:
	Hud.health_display.health = health
	Hud.show()


func _ready() -> void:
	reset()
	equip_spell(preload("res://player/spells/test_spell/test_spell.tscn"))


func take_damage(damage : int) -> void:
	health -= damage
	
	
func take_knockback(knock : Vector2) -> void:
	velocity += knock
	
	
func die() -> void:
	print("You have died")


func _physics_process(_delta) -> void:
	
	if Input.is_action_pressed("player_sprint"):
		effective_max_speed = max_sprint_speed
	else:
		effective_max_speed = max_walk_speed
	
	#get lateral input
	var lateral_acceleration : int = 0
	if Input.is_action_pressed("player_right"):
		lateral_acceleration += walk_accel
		direction = Vector2.RIGHT
		
	if Input.is_action_pressed("player_left"):
		lateral_acceleration -= walk_accel
		direction = Vector2.LEFT
		
	#apply max speed
	if abs(velocity.x + lateral_acceleration) < effective_max_speed:
		velocity.x += lateral_acceleration
		
	#apply friction
	var velocity_sign : int = sign(velocity.x)
	var pos_v : float = abs(velocity.x)
	if is_on_floor():
		pos_v -= friction
	pos_v = max(0, pos_v)
	#apply max walk speed
	#pos_v = min(pos_v, max_walk_speed)
	velocity.x = velocity_sign * pos_v
	
	if is_on_floor():
		velocity.y = 0
		if Input.is_action_just_pressed("player_jump"):
			velocity.y -= jump_accel
	else:
		velocity.y += gravity
	
	move_and_slide()
	
	if position.y > death_altitude:
		take_damage(max_health)
	

func equip_spell(spell_scene : PackedScene) -> void:
	var spell : Spell = spell_scene.instantiate()
	for equiped_spell in spell_manager.get_children():
		if equiped_spell.id == spell.id:
			push_warning("Trying to equip spell that is already equipped")
			return
	Hud.spell_display_manager.add_spell(spell)
	spell_manager.add_child(spell)
	
