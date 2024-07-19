class_name SpellDisplayManager
extends Control


@export var spell_display_scene : PackedScene
var spells : Array[Spell] = []


func add_spell(spell : Spell) -> void:
	var _useless_variable = spell.menu_data #removing this line breaks the game
	spells.append(spell)
	var new_display : SpellDisplay = spell_display_scene.instantiate()
	new_display.spell = spell
	$GridContainer.add_child(new_display)
	
	custom_minimum_size = $GridContainer.get_minimum_size()
	
	
func clear_spells() -> void:
	spells = []
	for child in $GridContainer.get_children():
		child.queue_free()
	custom_minimum_size = $GridContainer.get_minimum_size()
