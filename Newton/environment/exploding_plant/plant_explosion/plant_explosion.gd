extends Explosion

	
func _process(delta):
	super(delta)
	if use_built_in_animation:
		$Sprite2D.scale.x = radius / starting_radius
		$Sprite2D.scale.y = radius / starting_radius
