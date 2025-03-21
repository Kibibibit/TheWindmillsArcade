extends VectorRenderer
class_name AsteroidsBullet

const SPEED: float = 400.0

@onready
var area_2d: Area2D = $Area2D
@onready
var collision_shape: CollisionPolygon2D = $Area2D/CollisionShape2D

var velocity: Vector2


func _ready() -> void:
	area_2d.area_entered.connect(_entered_area)


func _process(delta: float) -> void:
	
	position += velocity*delta
	
	draw_vector_from_polygon(collision_shape.polygon)
	queue_redraw()
	
	if position.distance_to(get_viewport_rect().get_center()) > 1000.0:
		kill()

func _entered_area(area:Area2D) -> void:
	var area_parent: Node2D = area.get_parent()
	if area_parent is AsteroidsAsteroid:
		area_parent.shatter()
		kill.call_deferred()
		

func kill() -> void:
	if !is_queued_for_deletion():
		self.get_parent().remove_child(self)
		self.queue_free()
