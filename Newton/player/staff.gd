extends Sprite2D

@onready var player = get_parent()

var follow_mouse = false
var rotation_speed = 1000

func _process(delta):
	if follow_mouse:
		var mouse_pos = get_global_mouse_position()
		var angle_to_mouse = rad_to_deg((get_global_position() - mouse_pos).angle())
		if player.direction == Vector2.RIGHT:
			angle_to_mouse += 180
		# Ensure the target angle is within 180 degrees of the current rotation
		while angle_to_mouse - rotation_degrees > 180:
			angle_to_mouse -= 360
		while angle_to_mouse - rotation_degrees < -180:
			angle_to_mouse += 360
		rotation_degrees = move_toward(rotation_degrees, angle_to_mouse, rotation_speed * delta)

func start_following_mouse():
	follow_mouse = true

func stop_following_mouse():
	follow_mouse = false
