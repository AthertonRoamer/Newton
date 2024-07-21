class_name FireBallExplosion
extends Explosion


@onready var firebomb :GPUParticles2D = $firebomb
@onready var fire_mat : ParticleProcessMaterial = firebomb.process_material
#@onready var player = Main.world.Player
@export var sound : AudioStream
var wielder : Player

func _ready() -> void:
	super()
	wielder.screen_shake(.75,8)
	AudioManager.play(sound)
	$AnimationPlayer.play("explode",-1,3.0)

func _process(delta):
	super(delta)
	if use_built_in_animation:
		$Sprite2D.scale.x = radius / starting_radius
		$Sprite2D.scale.y = radius / starting_radius
		#fire_mat.scale_max = radius / starting_radius
		#fire_mat.scale_min = radius / starting_radius


func effect_body(body : Node2D) -> void:
	if body.is_in_group("damageable"):
		if is_instance_valid(wielder):
			body.take_damage(damage, damage_type, wielder)
		else:
			body.take_damage(damage, damage_type)
	if body.is_in_group("knockable"):
		body.take_knockback(global_position.direction_to(body.global_position) * knockback_force)
