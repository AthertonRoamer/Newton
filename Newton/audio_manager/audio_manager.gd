class_name AudioManagerClass
extends Node

@export var audio_player_count : int = 10

var audio_players : Array[AudioStreamPlayer] = []  # The available players.
var queue : Array = []  # The queue of sounds to play.

func _ready():
	# Create the pool of AudioStreamPlayer nodes.
	for i in audio_player_count:
		var p = AudioStreamPlayer.new()
		add_child(p)
		audio_players.append(p)
		

func play(sound : AudioStream):
	if sound != null:
		queue.append(sound)


func _process(_delta):
	# Play a queued sound if any players are available.
	if not queue.is_empty():
		var available_players : Array[AudioStreamPlayer] = audio_players.filter(is_stream_stopped)
		if not available_players.is_empty():
			var player = available_players.pop_back()
			player.stream = queue.pop_front()
			player.play()


func is_stream_stopped(player):
	return not player.playing
	
