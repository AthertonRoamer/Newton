extends EntityState

@export var sound : AudioStream

func _ready() -> void:
	AudioManager.play(sound)

