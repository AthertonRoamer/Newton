class_name SpellMenuData
extends Resource

signal available_changed(available : bool)
signal time_till_available_changed(time_till_available : float)
signal selected_changed(selected : bool)

@export var texture : Texture
@export var name : String
@export var description : String

var selected : bool = false:
	set(v):
		if v != selected:
			selected = v
			selected_changed.emit(selected)

var available : bool = true:
	set(v):
		if v != available:
			available = v
			available_changed.emit(available)
			
var time_till_available : float = 0.0:
	set(v):
		if v != time_till_available:
			time_till_available = v
			time_till_available_changed.emit(time_till_available)
