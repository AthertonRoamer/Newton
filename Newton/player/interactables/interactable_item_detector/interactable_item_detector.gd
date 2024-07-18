class_name InteractableItemDetector
extends Area2D

var player : Player

func interact() -> void:
	for area in get_overlapping_areas():
		if area.is_in_group("interactable"):
			area.interact(player)
			break
