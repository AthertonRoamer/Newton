class_name MainThemePlayer
extends AudioStreamPlayer


func _on_finished():
	play(0.0)
	
	
func play_from_start() -> void:
	play(0.0)
