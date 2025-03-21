extends VectorRenderer
class_name AsteroidsPlayer

signal shoot(pos: Vector2, velocity: Vector2)

@onready var collision_shape: CollisionPolygon2D = $Area2D/CollisionPolygon2D
@onready var area_2d: Area2D = $Area2D
@onready var bullet_spawn: Node2D = $Marker2D

@export var max_speed : float = 200.0
@export var acceleration : float = 200.0
@export var friction : float = 10.0
@export var max_turn_speed : float = 8.0
@export var turn_accel : float = 7.0
@export var shoot_speed: float = 0.25


var velocity: Vector2 = Vector2.ZERO
var angular_velocity: float = 0.0

var shoot_timer: float = 0.0

@onready
var screen_width: float = get_viewport_rect().size.x
@onready
var screen_height: float = get_viewport_rect().size.y


func _process(delta: float) -> void:
	
	if Input.is_action_pressed("ui_accept"):
		if shoot_timer <= 0.0:
			shoot.emit(bullet_spawn.global_position, Vector2.from_angle(rotation)*AsteroidsBullet.SPEED)
			shoot_timer = shoot_speed
	
	shoot_timer -= delta
	
	var accel_input : bool = Input.is_action_pressed("ui_up")
	var turn_input : float = Input.get_axis("ui_left", "ui_right")
	
	angular_velocity = move_toward(angular_velocity, turn_input*max_turn_speed, delta*turn_accel)
	
	rotation += angular_velocity*delta
	
	
	
	var accel_vector : Vector2 = Vector2.from_angle(rotation) if accel_input else Vector2.ZERO
	
	var delta_v : float = friction if is_zero_approx(accel_input) else acceleration
	
	velocity = velocity.move_toward(accel_vector*max_speed, delta*delta_v)
	
	
	position += velocity*delta
	
	if position.x >= screen_width:
		position.x -= screen_width
	if position.x < 0:
		position.x += screen_width
	if position.y >= screen_height:
		position.y -= screen_height
	if position.y < 0:
		position.y += screen_height
	
	draw_vector_from_polygon(collision_shape.polygon)
	queue_redraw()
