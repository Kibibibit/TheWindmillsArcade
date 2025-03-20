extends Button
class_name GameSelectButton


@export
var game_scene: PackedScene


func _ready() -> void:
	self.pressed.connect(_start_game)


func _start_game() -> void:
	get_tree().change_scene_to_packed(game_scene)
