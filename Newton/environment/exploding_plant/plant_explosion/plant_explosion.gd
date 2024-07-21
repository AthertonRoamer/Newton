extends Explosion


@export var sound : AudioStream
func  _ready() -> void:
	super()
	$AnimationPlayer.play("explode")
	AudioManager.play(sound)
	
func _process(delta):
	super(delta)
	if use_built_in_animation:
		$Sprite2D.scale.x = radius / starting_radius
		$Sprite2D.scale.y = radius / starting_radius
