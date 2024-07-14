class_name SpellDisplay
extends TextureRect

var spell : Spell

func _ready() -> void:
	$SpellTextureHolder.texture = spell.menu_data.texture
