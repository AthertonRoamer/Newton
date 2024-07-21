class_name Lightning
extends Node2D

@export var lightning_explosion : LightningExplosion
@export var sound : AudioStream

func _ready() -> void:
	$AnimationPlayer.play("strike",-1,1.5)
	AudioManager.play(sound)
	
