extends StaticBody2D
class_name BlockBreakerPlayer

@export
var width: int = 4

@onready
var right_end_cap: Sprite2D = $RightEndCap
@onready
var left_end_cap: Sprite2D = $LeftEndCap

@onready
var main_bar: Sprite2D = $MainBar

@onready
var collision_shape: CollisionShape2D = $CollisionShape2D

@export
var player_speed: float = 300.0

var min_x: float = 0.0
var max_x: float = 0.0


func _ready() -> void:
	var endcap_offset: float = (width/2.0)*16 + 8
	main_bar.scale.x = width
	right_end_cap.position.x = endcap_offset
	left_end_cap.position.x = -endcap_offset
	var collision_shape_width : float = (width*16)+32
	(collision_shape.shape as RectangleShape2D).size.x = collision_shape_width
	
	## Makes the collsion box a little more leniant while still looking like its not
	min_x = (16*7)+(collision_shape_width-12)/2
	max_x = get_viewport_rect().size.x - (16*7) - (collision_shape_width-12)/2


func _process(delta: float) -> void:
	
	var move_direction := Input.get_axis("ui_left", "ui_right")
	
	position.x += move_direction*player_speed*delta
	
	position.x = clampf(position.x, min_x, max_x)
	
	
	
