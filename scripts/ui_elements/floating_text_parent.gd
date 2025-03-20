extends Control
class_name FloatingTextParent

var _floating_text_scene: PackedScene = preload("res://prefabs/floating_text/floating_text.tscn")


func display_text(text: String, pos:Vector2, color: Color = Color.WHITE) -> void:
	var floating_text : FloatingText = _floating_text_scene.instantiate()
	
	floating_text.label_text = text
	floating_text.position = pos
	floating_text.text_color = color
	
	add_child(floating_text)
