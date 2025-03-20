extends Control
class_name FloatingText
@onready
var label: Label = $Label
@onready
var animation_player: AnimationPlayer = $AnimationPlayer
var label_text: String

@export
var text_color: Color = Color.YELLOW
@export
var outline_color: Color = Color.BLACK

@export
var opacity: float = 1.0

func _ready() -> void:
	label.text = label_text
	animation_player.play("floating_text")
	label.add_theme_color_override("font_color", text_color)
	label.add_theme_color_override("font_outline_color", outline_color)

func _process(_delta: float) -> void:
	label.remove_theme_color_override("font_color")
	label.remove_theme_color_override("font_outline_color")
	text_color.a = opacity
	outline_color.a = opacity
	label.add_theme_color_override("font_color", text_color)
	label.add_theme_color_override("font_outline_color", outline_color)
func _done() -> void:
	self.get_parent().remove_child(self)
	self.queue_free()
