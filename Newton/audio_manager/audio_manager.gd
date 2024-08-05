class_name AudioManagerClass
extends Node

@export var audio_player_count : int = 20

var audio_players : Array[AudioStreamPlayer] = []  # The available players.
var queue : Array = []  # The queue of sounds to play.

func _ready():
	# Create the pool of AudioStreamPlayer nodes.
	for i in audio_player_count:
		var p = AudioStreamPlayer.new()
		add_child(p)
		audio_players.append(p)
		

func play(sound : AudioStream, volume_db : float = 0.0):
	if sound != null:
		var sound_data : SoundData = SoundData.new()
		sound_data.sound = sound
		sound_data.volume_db = volume_db
		queue.append(sound_data)
		

func stop():
	queue.clear()

func _process(_delta):
	# Play a queued sound if any players are available.
	if not queue.is_empty():
		var available_players : Array[AudioStreamPlayer] = audio_players.filter(is_stream_stopped)
		if not available_players.is_empty():
			var player = available_players.pop_back()
			var sound_data = queue.pop_front()
			player.stream = sound_data.sound
			player.volume_db = sound_data.volume_db
			player.play()


func is_stream_stopped(player):
	return not player.playing
	
