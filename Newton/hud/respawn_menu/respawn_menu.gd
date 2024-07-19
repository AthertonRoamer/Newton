extends Control

var total_respawn : bool = false

func _on_respawn_button_pressed():
	if total_respawn:
		total_respawn = false
		hide()
		Main.world.level_segment_manager.load_level_segment_by_index(PlayerData.total_death_respawn_level_index)
	else:
		hide()
		Main.world.level_segment_manager.reload_active_segment()
		pass
		
		
func show_menu() -> void:
	if total_respawn:
		$RespawnButton.text = "You have lost all your lives\nRespawn at last major checkpoint"
	else:
		$RespawnButton.text = "Respawn"
	show()
