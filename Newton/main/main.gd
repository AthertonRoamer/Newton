class_name Main
extends Node

static var main : Main
static var world : World
static var player : Player

@export var menu_scene : PackedScene
@export var game_scene : PackedScene
var game : Node
var menu : Control


func _ready() -> void:
	main = self
	load_main_menu()
	
	
func load_main_menu() -> void:
	menu = menu_scene.instantiate()
	add_child(menu)
	
	
func load_game() -> void:
	if game_scene != null:
		menu.queue_free()
		game = game_scene.instantiate()
		add_child(game)
		
		
func exit_game_to_menu() -> void:
	if is_instance_valid(game):
		Hud.visible = false
		game.queue_free()
		load_main_menu()
