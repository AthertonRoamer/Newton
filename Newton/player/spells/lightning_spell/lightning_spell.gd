class_name LightningSpell
extends Spell

@export var lightning_scene : PackedScene

func cast() -> void:
	spawn_lightning()
	super()


func spawn_lightning() -> void:
	pass
