extends Sprite2D

@export var limit_staff_angle_to_forward = true
@onready var player = get_parent()

var follow_mouse = false
var rotation_speed = 1000

func _process(delta):
	if follow_mouse:
		var mouse_pos = get_global_mouse_position()
		var angle_to_mouse = rad_to_deg((get_global_position() - mouse_pos).angle())

		if limit_staff_angle_to_forward:
			#this makes so player can't aim staff behind himself
			var direction_angle_to_mouse = rad_to_deg((mouse_pos - player.get_global_position()).angle_to(player.direction))
			if direction_angle_to_mouse > 90:
				var vec = Vector2.UP.rotated(0.1)
				if player.direction == Vector2.RIGHT:
					vec = Vector2.DOWN
				angle_to_mouse =  rad_to_deg((get_global_position() - player.get_global_position() + vec).angle())
			elif direction_angle_to_mouse < -90:
				var vec2 = Vector2.DOWN.rotated(0.1)
				if player.direction == Vector2.RIGHT:
					vec2 = Vector2.UP
				angle_to_mouse =  rad_to_deg((get_global_position() - player.get_global_position() + vec2).angle())
			
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
