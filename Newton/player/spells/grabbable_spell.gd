class_name GrabbableSpell
extends InteractableItem

@export var spell_scene : PackedScene

func interact(player : Player) -> void:
	super(player)
	player.equip_spell(spell_scene) 
