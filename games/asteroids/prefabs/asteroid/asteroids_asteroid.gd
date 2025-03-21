extends VectorRenderer
class_name AsteroidsAsteroid


const SIZES: Array[int] = [16, 32, 64]
const VARIANCE: Array[int] = [6, 9, 12]
const SEGMENTS: Array[int] = [8, 12, 16]
const PIECES: Array[int] = [0, 2, 4]
const SCORES: Array[int] = [100, 150, 200]

const MIN_SPEED: float = 2.0
const MAX_SPEED: float = 20.0

var _asteroid_scene: PackedScene = preload("res://games/asteroids/prefabs/asteroid/asteroids_asteroid.tscn")

@onready
var area2d: Area2D = $Area2D
@onready
var collision_shape: CollisionPolygon2D = $Area2D/CollisionShape2D
@onready
var screen_width: float = get_viewport_rect().size.x
@onready
var screen_height: float = get_viewport_rect().size.y

var velocity: Vector2 = Vector2.ZERO
var angular_velocity: float = 0.0
var game_scene: AsteroidsGame


var size: int = 1

func _ready() -> void:
	
	var angle_d: float = (2.0*PI)/SEGMENTS[size]
	game_scene.asteroid_count += 1
	
	var point_set: PackedVector2Array = []
	
	for a in range(SEGMENTS[size]):
		
		var d: float = SIZES[size] + randf_range(-VARIANCE[size], VARIANCE[size])
		
		point_set.append(Vector2.from_angle(a*angle_d)*d)
	
	collision_shape.set_deferred("polygon", point_set)
	
	angular_velocity = randf_range(-MIN_SPEED, MIN_SPEED)

	


func shatter() -> void:
	
	game_scene.add_score(SCORES[size], global_position)
	game_scene.asteroid_count -= 1
	
	var new_size: int = size - 1
	if new_size >= 0:
		var angle_d: float = (2.0*PI)/PIECES[size]
		var random_offset: float = randf()*2.0*PI
		for a in PIECES[size]:
			var spawn_pos: Vector2 = Vector2.from_angle(a*angle_d + random_offset) * SIZES[size]*0.8
			var new_asteroid: AsteroidsAsteroid = _asteroid_scene.instantiate()
			new_asteroid.size = new_size
			new_asteroid.global_position = to_global(spawn_pos)
			new_asteroid.game_scene = self.game_scene
			new_asteroid.velocity = Vector2.from_angle(a*angle_d + random_offset) * randf_range(MAX_SPEED,MAX_SPEED*1.5)
			get_parent().add_child(new_asteroid)
	self.get_parent().remove_child(self)
	self.queue_free()

func _process(delta: float) -> void:
	
	position += velocity*delta
	rotation += angular_velocity*delta
	
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
	
