class_name Player
extends CharacterBody2D

@export var walk_accel : int = 80
@export var friction : int = 30
@export var max_walk_speed : int = 350
@export var max_walk_speed_charging : int = 175
@export var max_sprint_speed : int = 500
var effective_max_speed : int

@export var jump_accel : int = 700
@export var gravity : int = PhysicsData.gravity_acceleration

@export var death_altitude : int = PhysicsData.death_altitude

@export var interactable_item_detector : InteractableItemDetector

var walking = false
var jumping = false
var falling = false
var charging = false
var charged = false

var direction : Vector2 = Vector2.RIGHT
var direction_locked = false

@export var max_health : int = 100
@export var starting_health : int = 100
var health : int = starting_health:
	set(v):
		if v <= 0:
			health = 0
			die()
		else:
			health = v
		Hud.health_display.health = health
			


@export var spell_manager : SpellManager

@onready var player_cam = $Camera2D
@onready var player_sprite = $Sprite2D
@onready var staff_sprite = $staff
@onready var anim_p = $AnimationPlayer


@onready var test_label = $Label


func _ready() -> void:
	reset()
	Main.player = self
	equip_spell(preload("res://player/spells/test_spell/test_spell.tscn"))
	
	
func reset() -> void:
	health = starting_health
	Hud.health_display.health = health
	Hud.show()
	interactable_item_detector.player = self


func take_damage(damage : int, _damage_type : String = "none") -> void:
	health -= damage


func take_knockback(knock : Vector2) -> void:
	velocity += knock


func die() -> void:
	print("You have died")


func _input(event : InputEvent) -> void:
	if event.is_action("player_cast"):
		if not event.is_echo():
			if event.is_pressed():
				begin_charging_spell()
			else:
				cast_spell()
	elif event.is_action("select_spell_up"):
		if not event.is_echo() and event.is_pressed():
			shift_to_spell_up()
	elif event.is_action("select_spell_down"):
		if not event.is_echo() and event.is_pressed():
			shift_to_spell_down()
	elif event.is_action("player_select_spell_one"):
		if not event.is_echo() and event.is_pressed():
			if spell_manager.spell_count > 0:
				spell_manager.select_spell_by_num(0)
	elif event.is_action("player_select_spell_two"):
		if not event.is_echo() and event.is_pressed():
			if spell_manager.spell_count > 1:
				spell_manager.select_spell_by_num(1)
	elif event.is_action("player_select_spell_three"):
		if not event.is_echo() and event.is_pressed():
			if spell_manager.spell_count > 2:
				spell_manager.select_spell_by_num(2)
	elif event.is_action("player_select_spell_four"):
		if not event.is_echo() and event.is_pressed():
			if spell_manager.spell_count > 3:
				spell_manager.select_spell_by_num(3)
	elif event.is_action("player_interact"):
		if not event.is_echo() and event.is_pressed():
			interactable_item_detector.interact()


func equip_spell(spell_scene : PackedScene) -> void:
	var spell : Spell = spell_scene.instantiate()
	for equiped_spell in spell_manager.get_children():
		if equiped_spell.id == spell.id:
			push_warning("Trying to equip spell that is already equipped")
			return
	Hud.spell_display_manager.add_spell(spell)
	spell_manager.add_spell(spell)
	if spell_manager.spell_count == 1:
		spell_manager.select_spell_by_num(0)


func begin_charging_spell() -> void:
	if spell_manager.selected_spell.available:
		spell_manager.selected_spell.begin_charge()
		direction_locked = true
		charging = true
		staff_sprite.start_following_mouse()
		if !is_on_floor():
			falling = true


func cast_spell() -> void:
	if spell_manager.selected_spell.available and spell_manager.selected_spell.state == Spell.state_options.CHARGING:
		spell_manager.selected_spell.cast()



func shift_to_spell_up() -> void:
	var new_spell_num = (spell_manager.selected_spell_num + 1) % spell_manager.spell_count
	spell_manager.select_spell_by_num(new_spell_num)


func shift_to_spell_down() -> void:
	var new_spell_num = spell_manager.selected_spell_num - 1
	if new_spell_num == -1:
		new_spell_num = spell_manager.spell_count - 1
	spell_manager.select_spell_by_num(new_spell_num)


func _physics_process(_delta) -> void:
	mouse_actions()
	movement()
	update_player_visuals()
	
	if position.y > death_altitude:
		health = 0


func mouse_actions():
#	feel free to mess with this code this is just where
#	im putting the charge animation stuff (quick solution)
	if !Input.is_action_pressed("player_cast"):
		direction_locked = false
		charging = false
		charged = false
		staff_sprite.stop_following_mouse()


func movement():
	walking = false
	#if Input.is_action_pressed("player_sprint"):
		#effective_max_speed = max_sprint_speed
	#else:
	if !charging:
		effective_max_speed = max_walk_speed
	else:
		effective_max_speed = max_walk_speed_charging
	
	#get lateral input
	var lateral_acceleration : int = 0
	if Input.is_action_pressed("player_right"):
		lateral_acceleration += walk_accel
		if !direction_locked:
			direction = Vector2.RIGHT
		walking = true
		
	if Input.is_action_pressed("player_left"):
		lateral_acceleration -= walk_accel
		if !direction_locked:
			direction = Vector2.LEFT
		walking = true
		
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
		if velocity.y > 0:
			velocity.y = 0
		if Input.is_action_just_pressed("player_jump"):
			velocity.y -= jump_accel
			jumping = true

	else:
		velocity.y += gravity
	
	move_and_slide()


func update_player_visuals():
	flip_player()
	player_animations()


func flip_player():
	if !direction_locked:
		match direction:
			Vector2.RIGHT:
				player_sprite.scale.x = 1
				staff_sprite.scale.x = 1
			Vector2.LEFT:
				player_sprite.scale.x = -1
				staff_sprite.scale.x = -1
				


func player_animations():
	if charging:
		if !charged:
			anim_p.play("wind_charging")
	else:
		if is_on_floor():
			if walking:
				if direction == Vector2.RIGHT:
					anim_p.play("walk_right")
					test_label.text = "walking"
				elif direction == Vector2.LEFT:
					anim_p.play("walk_left")
					test_label.text = "walking"
			else:
				anim_p.play("idle",-1,0.75)
				test_label.text = "idle"
		else:
			if jumping == true:
				anim_p.play("jump",-1,0.75)
				test_label.text = "jumping"
				jumping = false
			if falling == true:
				anim_p.play("fall")
				falling = false


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "charging":
		charged = true
		anim_p.play("full_charged")
	elif anim_name == "wind_charging":
		charged = true
		anim_p.play("wind_charged")
