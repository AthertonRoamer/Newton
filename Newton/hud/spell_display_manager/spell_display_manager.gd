class_name SpellDisplayManager
extends Control


@export var spell_display_scene : PackedScene
var spells : Array[SpellMenuData] = []


func add_spell(spell : Spell) -> void:
	spells.append(spell.menu_data)
	var new_display : SpellDisplay = spell_display_scene.instantiate()
	new_display.spell_menu_data = spell.menu_data
	$HBoxContainer.add_child(new_display)
	
	custom_minimum_size = $HBoxContainer.get_minimum_size()
	
	
