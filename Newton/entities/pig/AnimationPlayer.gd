extends AnimationPlayer


@export var goblin : Entity

@onready var sprite = $"../Sprite2D"
#@onready var weapon = $"../MeleeWeapon"
@onready var health = goblin.starting_health

var goblin_dir
var moving = false
var took_dmg = false
var dead = false
var still = true



func _on_walking_changed(walking : bool):
	moving = walking


func _on_direction_changed(new_direction : Vector2):
	goblin_dir = new_direction
	
	
func _on_health_changed(new_health : int):
	if health >= new_health:
		took_dmg = true
	health = new_health



	
	


func _on_death():
	dead = true

func _ready() -> void:
	goblin.walking_changed.connect(_on_walking_changed)
	goblin.direction_changed.connect(_on_direction_changed)
	goblin.health_changed.connect(_on_health_changed)
	goblin.deaded.connect(_on_death)
	



func _process(_delta: float) -> void:
	set_visuals()


func set_visuals():
	if dead:
		play("death",-1,1.5)
	else:
				if took_dmg == true:
					play("death")
					
		
			#if attacking:
				#if !swinging:
					#swinging = true
					#play("attack")
			
				if !moving:
					if !still:
						play("idle")
				elif moving:
					still = false
					play("walk",-1,0.75)
					match goblin_dir:
						Vector2.LEFT:
							sprite.scale.x = 2
						Vector2.RIGHT:
							sprite.scale.x = -2


func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == "damage":
		took_dmg = false
	if anim_name == "death":
		goblin.queue_free()
	
