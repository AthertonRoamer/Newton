class_name HUD
extends CanvasLayer

@export var health_display : HealthDisplay
@export var spell_display_manager : SpellDisplayManager

func _ready():
	hide()
