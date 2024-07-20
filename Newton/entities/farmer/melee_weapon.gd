class_name FarmerMeleeWeapon
extends MeleeWeapon

@export var strike_timer : Timer
@export var arm_length : int = 40

func strike() -> void:
	#striking = true
	strike_timer.start()
	timer.start()
	strike_began.emit()


func end_strike() -> void:
	super()


func _on_strike_timer_timeout() -> void:
	striking = true
	for body in get_overlapping_bodies():
		effect_body(body)
