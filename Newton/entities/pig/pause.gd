extends EntityState


@export var sound : AudioStream
@export var timer : Timer
var min_time : float = 1.0
var max_time : float = 3.0
var pause_time : float 

func activate() -> void:
	super()
	pause_time = randf_range(min_time, max_time)
	timer.wait_time = pause_time
	timer.start()


func _on_timer_timeout():
	#AudioManager.play(sound)
	if not get_entity().dead:
		state_machine.set_state("wander")
