class_name SpellDisplay
extends TextureRect

var spell : Spell

@export var spell_selected_background : Texture
@export var spell_deselected_background : Texture

@export var spell_available_modulate : Color
@export var spell_unavailable_modulate : Color

func _ready() -> void:
	$SpellTextureHolder.texture = spell.menu_data.texture
	
	spell.selected_changed.connect(_on_spell_selected_changed)
	spell.available_changed.connect(_on_spell_available_changed)
	spell.time_till_available_changed.connect(_on_spell_time_till_available_changed)
	
	
func _on_spell_selected_changed(spell_selected : bool) -> void:
	if spell_selected:
		texture = spell_selected_background
	else:
		texture = spell_deselected_background
	
	
func _on_spell_available_changed(spell_available : bool ) -> void:
	if spell_available:
		$SpellTextureHolder.modulate = spell_available_modulate
	else:
		$SpellTextureHolder.modulate = spell_unavailable_modulate
	
	
func _on_spell_time_till_available_changed(spell_time_till_available : float) -> void:
	if is_zero_approx(spell_time_till_available):
		$TimeTillAvailableDiaplay.text = ""
	else:
		$TimeTillAvailableDiaplay.text = str(round(spell_time_till_available * 10) / 10)
	
	
	
