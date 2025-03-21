extends Node2D
class_name VectorRenderer


@export var antialiased: bool = false

var _lines: Array[VectorLine] = []



func draw_vector(line: VectorLine) -> void:
	_lines.append(line)


func draw_vector_from_polygon(points: PackedVector2Array, color: Color = Color.WHITE, width: float = -1.0) -> void:
	for i in range(points.size()):
		var j: int = i+1
		if j >= points.size():
			j -= points.size()
		
		draw_vector(VectorLine.new(points[i], points[j], color, width))
		
		


func _draw() -> void:
	while not _lines.is_empty():
		var line: VectorLine = _lines.pop_front()
		draw_line(line.a, line.b, line.color, line.width, antialiased)
