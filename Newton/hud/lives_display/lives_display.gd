class_name LivesDisplay
extends Control

var lives : int = 0:
	set(v):
		lives = v
		update_display()
		
		
func _ready() -> void:
	update_display()
		
		
func update_display() -> void:
	$Label.text = "Lives: " + str(lives)
	custom_minimum_size = $Label.get_minimum_size()
		
		

