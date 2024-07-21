extends Node2D



@onready var label = $Label
@export var music : AudioStream

var step : int = 1
func _ready():
		$necro/AnimationPlayer.play("zap")
		AudioManager.play(music)
		do_tutorial()


func do_tutorial() -> void:
	match step:
		1:
			label.text = "Your master is dead."
		2:
			label.text = "He had taught you all you know."
		3:
			label.text = "He was murdered by the all-powerful necromancer"
			$necro.visible = true
		4:
			label.text = "You must seek out the revival stone."
		5:
			label.text = "Only through it, may your master return."
		6:
			label.text = "The journey will not be easy, however."
		7:
			label.text = "With only your master's wand and a couple years of teaching, you must take on the necromancer's forces yourself."
		8:
			label.text = "Goodluck."
		9:
			label.text = "Controls- WASD to move, mouse to aim/attack."
		10:
			label.text = "Hold mouse to charge spells."
		11:
			label.text = "This will make them more powerful(in many ways)."
			$Button.text = "Exit tutorial"
		_:
			exit_tutorial()



func _on_button_pressed():
	step += 1
	do_tutorial()
	
	
func exit_tutorial() -> void:
	visible = false
