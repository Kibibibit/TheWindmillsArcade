extends Node
class_name AudioPlayer

@export
var volume_db: float = 0.0

@export
var sounds: Dictionary[StringName, AudioStreamWAV] = {}

var players: Dictionary[StringName, AudioStreamPlayer] = {}

func _ready() -> void:
	for sound in sounds:
		var stream_player := AudioStreamPlayer.new()
		stream_player.autoplay = false
		stream_player.stream = sounds[sound]
		stream_player.volume_db = volume_db
		add_child(stream_player)
		players[sound] = stream_player


func play_sound(sound_name: StringName) -> void:
	players[sound_name].play()
