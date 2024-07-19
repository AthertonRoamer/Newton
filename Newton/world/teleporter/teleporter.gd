extends InteractableItem
class_name Teleporter


func interact(player : Player) -> void:
	super(player)
	Main.world.level_segment_manager.transfer_to_next_segment()

func _ready() -> void:
	super()
	player_entered_range.connect(_on_player_enter_range)
	player_exited_range.connect(_on_player_exit_range)
	
	
func _on_player_enter_range() -> void:
	$Label.show()
	
	
func _on_player_exit_range() -> void:
	$Label.hide()
