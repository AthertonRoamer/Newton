class_name GoblinMeleeWeapon
extends MeleeWeapon

@export var arm_length : int = 40

func strike() -> void:
	position = get_parent().direction * arm_length
	visible = true
	super()


func end_strike() -> void:
	super()
	visible = false
