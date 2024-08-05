class_name Lightning
extends Node2D

@export var lightning_explosion : LightningExplosion
@export var sound : AudioStream
@export var ground_finder : RayCast2D
@export var y_offset : float = 60

func _ready() -> void:
	move_to_ground()
	$AnimationPlayer.play("strike",-1,1.5)
	AudioManager.play(sound)
	
	
func move_to_ground() -> void:
	ground_finder.force_raycast_update()
	if ground_finder.is_colliding():
		global_position = ground_finder.get_collision_point()
		global_position.y -= y_offset

	
