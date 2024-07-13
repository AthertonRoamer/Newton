class_name SpellManager
extends Node

var selected_spell : Spell

func select_spell_by_num(num : int) -> void:
	if num <= get_child_count() - 1:
		var new_selected_spell = get_child(num)
		if selected_spell != new_selected_spell:
			selected_spell.menu_data.selected = false
			selected_spell = new_selected_spell
			selected_spell.menu_data.selected = true
