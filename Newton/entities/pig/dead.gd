extends EntityState

@export var sound : AudioStream

func activate() -> void:
	super()
	AudioManager.play(sound)

