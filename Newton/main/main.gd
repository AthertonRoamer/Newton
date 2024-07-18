class_name Main
extends Node

static var main : Main
static var world : World
static var player : Player

@export var menu_scene : PackedScene
@export var game_scene : PackedScene


func _ready() -> void:
	main = self
	load_main_menu()
	
	
func load_main_menu() -> void:
	var menu = menu_scene.instantiate()
	add_child(menu)
	
	
func load_game() -> void:
	if game_scene != null:
		var game = game_scene.instantiate()
		add_child(game)
