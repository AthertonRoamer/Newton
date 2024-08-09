class_name HUD
extends CanvasLayer

@export var health_display : HealthDisplay
@export var lives_display : LivesDisplay
@export var spell_display_manager : SpellDisplayManager
@export var respawn_menu : Control

func _ready():
	hide()
	
	
func set_lives_active(active : bool) -> void:
	lives_display.visible = active
