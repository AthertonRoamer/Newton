class_name HealthDisplay
extends Control

var health : int = 0:
	set(v):
		health = v
		update_display()
		
		
func _ready() -> void:
	update_display()
		
		
func update_display() -> void:
	$Label.text = "Health: " + str(health)
		
		

