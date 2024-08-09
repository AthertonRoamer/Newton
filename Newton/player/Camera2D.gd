class_name ShakeableCamera
extends Camera2D

var shake_amount = 5
var default_offset = offset
var shaking : bool = false
var vibrating : bool = false

var time_counter : float = 0.0
@export var vibrate_speed : float = 300
@export var vibrate_distance : float = 0

@onready var tween
@onready var timer = $"../shake_timer"

func _ready():
	randomize()

func _process(delta):
	offset = default_offset
	if vibrating:
		time_counter += delta * vibrate_speed
		var quantity : float = sin(time_counter) * vibrate_distance
		offset += Vector2(quantity, quantity)
	else:
		time_counter = 0

	if shaking:
		offset += Vector2(randf_range(-1, 1) * shake_amount, randf_range(-1, 1) * shake_amount)


func shake(time, amount):
	timer.wait_time = time
	shake_amount = amount
	shaking = true
	timer.start()
	
	
func set_vibration_distance(distance : float) -> void:
	vibrate_distance = distance
	vibrating = vibrate_distance > 0
	

func _on_shake_timer_timeout() -> void:
	shaking = false
	#tween.interpolate_property(self, "offset", offset, default_offset, 0.1, 6, 2)
	#tween.start()
