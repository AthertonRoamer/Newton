class_name InteractableItem
extends Area2D

signal player_entered_range
signal player_exited_range
signal interacted_with

func _ready() -> void:
	add_to_group("interactable")
	set_collision_layer_value(2, true)
	set_collision_mask_value(2, true)
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	
	
func interact(_player : Player) -> void:
	interacted_with.emit()
	
	
func _on_area_entered(area : Area2D) -> void:
	if area is InteractableItemDetector:
		player_entered_range.emit()
		
		
func _on_area_exited(area : Area2D) -> void:
	if area is InteractableItemDetector:
		player_exited_range.emit()
