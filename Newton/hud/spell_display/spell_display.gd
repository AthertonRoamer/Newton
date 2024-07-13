class_name SpellDisplay
extends TextureRect

var spell_menu_data : SpellMenuData

func _ready() -> void:
	$SpellTextureHolder.texture = spell_menu_data.texture
