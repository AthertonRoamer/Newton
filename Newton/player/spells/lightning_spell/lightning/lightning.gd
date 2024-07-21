class_name Lightning
extends Node2D

@export var lightning_explosion : LightningExplosion


func _ready() -> void:
	$AnimationPlayer.play("strike",-1,1.5)
