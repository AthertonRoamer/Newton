class_name SpellManager
extends Node

var selected_spell : Spell
var selected_spell_num : int = 0:
	set(v):
		selected_spell_num = v
		PlayerData.selected_spell_num = selected_spell_num

var spell_count : int = 0

func add_spell(spell : Spell) -> void:
	add_child(spell)
	spell_count += 1


func select_spell_by_num(num : int) -> void:
	if num <= get_child_count() - 1:
		var new_selected_spell : Spell = get_child(num)
		if selected_spell != new_selected_spell:
			if selected_spell != null:
				selected_spell.selected = false
			selected_spell = new_selected_spell
			selected_spell.selected = true
			selected_spell_num = num
			var frame_id : int = selected_spell.staff_frame_id
			selected_spell.player.change_staff_color(frame_id)
	else:
		push_warning("Spell manager is trying to select an invalid spell num")
