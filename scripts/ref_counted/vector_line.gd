extends RefCounted
class_name VectorLine


var a: Vector2
var b: Vector2

var color: Color
var width: float

func _init(_a: Vector2, _b: Vector2, _color: Color = Color.WHITE, _width: float = -1.0) -> void:
	a = _a
	b = _b
	color = _color
	width = _width

func length() -> float:
	return a.distance_to(b)
