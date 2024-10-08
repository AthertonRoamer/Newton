extends AnimationPlayer


@export var ranged : Ranged

@onready var sprite = $"../Sprite2D"
@onready var weapon = $"../FirePosition"
@onready var health = ranged.starting_health

var ranged_dir
var moving = false
var took_dmg = false
var taking_dmg = false
var dead = false
var still = true
var attacking = false
var swinging = false

func _on_walking_changed(walking : bool):
	moving = walking


func _on_direction_changed(new_direction : Vector2):
	ranged_dir = new_direction


func _on_health_changed(new_health : int):
	if health > new_health:
		took_dmg = true
		


func _on_strike_began():
	attacking = true


func _on_strike_ended() -> void:
	attacking = false
	swinging = false


func _on_death():
	dead = true

func _ready() -> void:
	ranged.walking_changed.connect(_on_walking_changed)
	ranged.direction_changed.connect(_on_direction_changed)
	ranged.health_changed.connect(_on_health_changed)
	ranged.dead.connect(_on_death)
	ranged.projectile_handler.fire_began.connect(_on_strike_began)
	ranged.projectile_handler.fire_ended.connect(_on_strike_ended)
	#ranged.weapon.strike_began.connect(_on_strike_began)
	#ranged.weapon.strike_ended.connect(_on_strike_ended)



func _process(_delta: float) -> void:
	set_visuals()


func set_visuals():
	if dead:
		if current_animation != "death":
			play("death")
			print("death")
	else:
		if took_dmg == true:
			if !taking_dmg:
				play("damage")
				taking_dmg = true
		else:
			if attacking:
				match ranged_dir:
						Vector2.LEFT:
							sprite.scale.x = -3.5
							weapon.scale.x = -3.5
						Vector2.RIGHT:
							sprite.scale.x = 3.5
							weapon.scale.x = 3.5
				if !swinging:
					swinging = true
					play("attack",-1,2.5)
			else:
				if !moving:
					if !still:
						play("idle",-1,0.5)
				elif moving:
					still = false
					play("walk",-1,0.75)
					match ranged_dir:
						Vector2.LEFT:
							sprite.scale.x = -3.5
							weapon.scale.x = -3.5
						Vector2.RIGHT:
							sprite.scale.x = 3.5
							weapon.scale.x = 3.5


func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == "damage":
		took_dmg = false
		taking_dmg = false
	if anim_name == "death":
		print("yo")
		ranged.queue_free()
	if anim_name == "attack":
		swinging = false
		attacking = false
