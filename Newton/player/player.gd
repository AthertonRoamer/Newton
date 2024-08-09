class_name Player
extends CharacterBody2D


@export var sound1 : AudioStream
@export var sound2 : AudioStream
@export var sound3 : AudioStream
@export var sound4 : AudioStream
@export var sound5 : AudioStream


@export var walk_accel : int = 100
@export var friction : int = 40
@export var max_walk_speed : int = 400
@export var max_walk_speed_charging : int = 175
@export var max_sprint_speed : int = 500
var effective_max_speed : int

@export var jump_accel : int = 700
@export var initial_jump_accel : int = 600
@export var continued_jump_accel : float = 29.5
@export var max_jump_time : float = 0.3

@export var using_lives : bool = false

@export var gravity : int = PhysicsData.gravity_acceleration

@export var death_altitude : int = PhysicsData.death_altitude

@export var interactable_item_detector : InteractableItemDetector
@export var staff_end_node : Node2D
@export var staff : Staff
@export var wind_burst_holder : Node2D

@export var camera : ShakeableCamera

var walking = false
var jumping = false
var falling = false
var charging = false
var charged = false
var shooting = false

var immune = true

var hurt = false
var hurting = false
var hurt_by_magic_overload : bool = false

var dead = false
var died = false

var direction : Vector2 = Vector2.RIGHT
var direction_locked = false

var current_jump_time : float = 0
var is_jumping : bool = false

@export var max_health : int = 100
@export var starting_health : int = 100
@export var starting_lives : int = 5
var health : int = starting_health:
	set(v):
		if v <= 0:
			health = 0
			die()
		else:
			health = v
		Hud.health_display.health = health
		PlayerData.health = health
		
		
var lives : int = starting_lives


@export var spell_manager : SpellManager


@onready var respawn_timer = $respawn_timer
@onready var player_sprite = $Sprite2D
@onready var staff_sprite = $staff
@onready var anim_p : AnimationPlayer = $AnimationPlayer


@onready var test_label = $Label

enum spawn_states {LOAD_IN, LEVEL_TRANSFER, RESPAWN, TOTAL_RESPAWN}
var spawn_state : spawn_states = spawn_states.LOAD_IN

var immune_to_spike_plant : bool = false

func play_cast_anim(anim_name : String) -> void:
	if anim_p.has_animation(anim_name):
		shooting = true
		anim_p.play(anim_name)
	

func _ready() -> void:
	$ImmuneToSpikeTimer.wait_time = SpikePlant.interlude_time
	Hud.set_lives_active(using_lives)
	Hud.spell_display_manager.clear_spells()
	match spawn_state:
		spawn_states.LEVEL_TRANSFER:
			load_persistent_player_data()
			load_temporary_player_data()
		spawn_states.RESPAWN:
			load_persistent_player_data()
			respawn_reset()
			restart_audio()
		spawn_states.LOAD_IN:
			reset_lives()
			restart_audio()
		spawn_states.TOTAL_RESPAWN:
			PlayerData.equipped_spells.clear()
			reset_lives()
			load_persistent_player_data()
			restart_audio()
	Hud.health_display.health = health
	Hud.show()
	interactable_item_detector.player = self
	Main.player = self


func restart_audio() -> void:
	if is_instance_valid(Main.main):
		if Main.main.game is MainWorld:
			(Main.main.game as MainWorld).audio_player.play_from_start()
		

func screen_shake(time,amount):
	camera.shake(time,amount)
	
	
func set_vibration_distance(distance) -> void:
	if not dead:
		camera.set_vibration_distance(distance)


func reset_lives() -> void:
	lives = starting_lives
	PlayerData.lives = lives
	Hud.lives_display.lives = lives
	
	
func load_persistent_player_data() -> void:
	var num = PlayerData.selected_spell_num
	for spell in PlayerData.equipped_spells.duplicate():
		equip_spell(spell)
	spell_manager.select_spell_by_num(num)
	lives = PlayerData.lives
		
		
func load_temporary_player_data() -> void:
	health = PlayerData.health
	
	
func respawn_reset() -> void:
	health = starting_health


func take_damage(damage : int, damage_type : String = "none", _damager : Node = null) -> void:
	if damage > 0:
		hurt = true
		hurt_by_magic_overload = damage_type == "magic_overload"
	if !immune:
		if damage_type == "spike_plant_first":
			if not is_on_floor() and velocity.y > 0:
				health -= SpikePlant.fall_on_spike_damage
			else:
				health -= damage
			immune_to_spike_plant = true
			$ImmuneToSpikeTimer.start()
		elif damage_type == "spike_plant":
			if not immune_to_spike_plant:
				health -= damage
				immune_to_spike_plant = true
				$ImmuneToSpikeTimer.start()
		else:
			health -= damage
		#hurt = true


func take_knockback(knock : Vector2) -> void:
	velocity += knock


func die() -> void:
	if !dead:
		camera.set_vibration_distance(0)
		dead = true
		respawn_timer.start()
		if using_lives:
			lives -= 1
			PlayerData.lives = lives
			Hud.lives_display.lives = lives
		#add camera to world where player was
		#in future, the camera instead of being a child of the player should follow the player to avoid this 
		var dead_cam = Camera2D.new()
		dead_cam.enabled = true
		dead_cam.global_position = $Camera2D.global_position
		Main.world.object_holder.add_child(dead_cam)
		#stop music
		if is_instance_valid(Main.main):
			if Main.main.game is MainWorld:
				(Main.main.game as MainWorld).audio_player.stop()
	


func total_death() -> void:
	print("You have totally died")
	Hud.respawn_menu.total_respawn = true
	Hud.respawn_menu.show_menu()
	queue_free()
	
	
func _input(event : InputEvent) -> void:
	if !dead:
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
	spell.player = self
	for equiped_spell in spell_manager.get_children():
		if equiped_spell.id == spell.id:
			push_warning("Trying to equip spell that is already equipped")
			return
	if not PlayerData.equipped_spells.has(spell_scene):
		PlayerData.equipped_spells.append(spell_scene)
	Hud.spell_display_manager.add_spell(spell)
	spell_manager.add_spell(spell)
	if spell_manager.spell_count == 1:
		spell_manager.select_spell_by_num(0)


func begin_charging_spell() -> void:
	if is_instance_valid(spell_manager.selected_spell) and spell_manager.selected_spell.available:
		spell_manager.selected_spell.begin_charge()
		direction_locked = true
		charging = true
		staff_sprite.start_following_mouse()
		if !is_on_floor():
			falling = true


func cast_spell() -> void:
	#if is_instance_valid(spell_manager.selected_spell) and spell_manager.selected_spell.available and spell_manager.selected_spell.state == Spell.state_options.CHARGING:
		#spell_manager.selected_spell.cast()
	#instead of firing only the selected spell, fire the charged spell
	for spell in spell_manager.get_children():
		spell = spell as Spell
		if spell.state == Spell.state_options.CHARGING:
			spell.cast()



func shift_to_spell_up() -> void:
	if spell_manager.spell_count == 0:
		return
	var new_spell_num = (spell_manager.selected_spell_num + 1) % spell_manager.spell_count
	spell_manager.select_spell_by_num(new_spell_num)


func shift_to_spell_down() -> void:
	if spell_manager.spell_count == 0:
		return
	var new_spell_num = spell_manager.selected_spell_num - 1
	if new_spell_num == -1:
		new_spell_num = spell_manager.spell_count - 1
	spell_manager.select_spell_by_num(new_spell_num)


func _physics_process(delta) -> void:
	mouse_actions()
	if !dead:
		movement(delta)
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


func movement(delta : float):
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
			velocity.y -= initial_jump_accel
			is_jumping = true
			jumping = true
	else:
		if is_jumping:
			velocity.y -= continued_jump_accel
			current_jump_time += delta
			if current_jump_time >= max_jump_time:
				is_jumping = false
				current_jump_time = 0
		if Input.is_action_just_released("player_jump"):
			is_jumping = false
			current_jump_time = 0
		velocity.y += gravity
		if sign(velocity.y) == 1:
			is_jumping = false
			current_jump_time = 0
	
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
				

func change_staff_color(frame_id ):
	$staff.frame = frame_id

func player_animations():
	if dead:
		if !died:
			if anim_p.current_animation != "death":
				anim_p.play("death")
				AudioManager.play(sound4)
	else:
		if hurt:
			if !hurting:
				if is_instance_valid(spell_manager.selected_spell):
					match spell_manager.selected_spell.id:
									"magic_missile":
										if hurt_by_magic_overload:
											anim_p.play("mm_hurt")
										else:
											anim_p.play("mm_hurt2")
									"fire_spell":
										if charging:
											anim_p.play("fire_hurt")
										else:
											anim_p.play("fire_hurt2")
									"wind_spell":
										if charging:
											anim_p.play("wind_hurt")
										else:
											anim_p.play("wind_hurt2")
									_:
										anim_p.play("hurt")
				else:
					anim_p.play("hurt")
				hurting = true
				shooting = false
				AudioManager.play(sound1)
		else:
			if !shooting:
				if charging:
					if !charged:
						if is_instance_valid(spell_manager.selected_spell):
							match spell_manager.charging_spell_id:
								"magic_missile":
									anim_p.play("mm_charging",-1,0.4)
								"fire_spell":
									anim_p.play("fire_charging")
								"wind_spell":
									anim_p.play("wind_charging")
								_:
									anim_p.play("charging")
						else:
							anim_p.play("charging")
						#AudioManager.play(sound4)
				else:
					if is_on_floor():
						if walking:
							if direction == Vector2.RIGHT:
								if is_instance_valid(spell_manager.selected_spell):
									match spell_manager.selected_spell.id:
										"magic_missile":
											anim_p.play("mm_walk_right")
										"fire_spell":
											anim_p.play("fire_walk_right")
										"wind_spell":
											anim_p.play("wind_walk_right")
										_:
											anim_p.play("walk_right")
								else:
									anim_p.play("walk_right")
							
							elif direction == Vector2.LEFT:
								if is_instance_valid(spell_manager.selected_spell):
									match spell_manager.selected_spell.id:
										"magic_missile":
											anim_p.play("mm_walk_left")
										"fire_spell":
											anim_p.play("fire_walk_left")
										"wind_spell":
											anim_p.play("wind_walk_left")
										_:
											anim_p.play("walk_left")
								else:
									anim_p.play("walk_left")
						else:
							if is_instance_valid(spell_manager.selected_spell):
								match spell_manager.selected_spell.id:
										"magic_missile":
											anim_p.play("mm_idle",-1,0.75)
										"fire_spell":
											anim_p.play("fire_idle",-1,0.75)
										"wind_spell":
											anim_p.play("wind_idle",-1,0.75)
										_:
											anim_p.play("idle",-1,0.75)
							else:
								anim_p.play("idle",-1,0.75)
							
					else:
						if jumping == true:
							if is_instance_valid(spell_manager.selected_spell):
								match spell_manager.selected_spell.id:
										"magic_missile":
											anim_p.play("mm_jump",-1,0.75)
										"fire_spell":
											anim_p.play("fire_jump",-1,0.75)
										"wind_spell":
											anim_p.play("wind_jump",-1,0.75)
										_:
											anim_p.play("jump",-1,0.75)
							else:
								anim_p.play("jump",-1,0.75)
							AudioManager.play(sound3)
							jumping = false
						if falling == true:
							if is_instance_valid(spell_manager.selected_spell):
								match spell_manager.selected_spell.id:
									"magic_missile":
										anim_p.play("mm_fall")
									"fire_spell":
										anim_p.play("fire_fall")
									"wind_spell":
										anim_p.play("wind_fall")
									_:
										anim_p.play("fall")
							else:
								anim_p.play("fall")
							falling = false


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	
	if anim_name == "wind_fire":
		shooting = false
	if anim_name == "lightning_shoot":
		shooting = false
	
	
	elif anim_name == "death":
		died = true
	
	elif anim_name == "charging":
		charged = true
		anim_p.play("full_charged")
	elif anim_name == "wind_charging":
		charged = true
		anim_p.play("wind_charged")
	elif anim_name == "mm_charging" :
		charged = true
		anim_p.play("mm_charged")
	elif anim_name == "fire_charging":
		charged = true
		anim_p.play("fire_charged")

	elif anim_name == "hurt":
		hurt = false
		hurting = false
	elif anim_name == "mm_hurt":
		hurt = false
		hurting = false
		hurt_by_magic_overload = false
		anim_p.play("mm_charged")
	elif anim_name == "mm_hurt2":
		hurt = false
		hurting = false
	elif anim_name == "fire_hurt":
		hurt = false
		hurting = false
		anim_p.play("fire_charged")
	elif anim_name == "fire_hurt2":
		hurt = false
		hurting = false
	elif anim_name == "wind_hurt":
		hurt = false
		hurting = false
		anim_p.play("wind_charged")
	elif anim_name == "wind_hurt2":
		hurt = false
		hurting = false
	


func _on_immune_to_spike_timer_timeout():
	immune_to_spike_plant = false


func _on_respawn_timer_timeout() -> void:
	if lives <= 0 and using_lives:
		total_death()
	else:
		print("You have died")
		Hud.respawn_menu.show_menu()
		queue_free()
	


func _on_spawn_timer_timeout() -> void:
	immune = false
