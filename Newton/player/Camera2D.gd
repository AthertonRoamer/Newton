extends Camera2D

var shake_amount = 5
var default_offset = offset
@onready var tween
@onready var timer = $"../shake_timer"

func _ready():
	set_process(false)
	randomize()

func _process(delta):
	offset = Vector2(randf_range(-1, 1) * shake_amount, randf_range(-1, 1) * shake_amount)

func shake(time, amount):
	timer.wait_time = time
	shake_amount = amount
	set_process(true)
	timer.start()



func _on_shake_timer_timeout() -> void:
	set_process(false)
	#tween.interpolate_property(self, "offset", offset, default_offset, 0.1, 6, 2)
	#tween.start()
