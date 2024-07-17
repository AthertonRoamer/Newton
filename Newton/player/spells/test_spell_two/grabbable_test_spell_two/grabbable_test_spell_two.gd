class_name GrabbableTestSpellTwo
extends GrabbableSpell

func interact(player) -> void:
	super(player)
	queue_free()
	
	
func _ready() -> void:
	super()
	player_entered_range.connect(_on_player_enter_range)
	player_exited_range.connect(_on_player_exit_range)
	
	
func _on_player_enter_range() -> void:
	$Label.show()
	
	
func _on_player_exit_range() -> void:
	$Label.hide()
