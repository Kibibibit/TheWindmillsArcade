extends StaticBody2D
class_name BlockBreakerBall

signal hit_tile(tile_coords: Vector2i)
signal hit_player()

@onready
var collision_shape: CollisionShape2D = $CollisionShape2D


@export
var speed: float = 100
@export
var paddle_normal_range: float = 10

var direction := Vector2(1,-1)

var moving: bool = false


func _physics_process(delta: float) -> void:
	if moving:
		var collision_info := move_and_collide(speed*direction*delta)
		if collision_info:
			
			var collider = collision_info.get_collider()
			
			var tile_to_hit := Vector2i.ZERO
			
			var tile := collision_info.get_position() - collision_info.get_normal()*2
			tile_to_hit = (tile/16).floor()
			
			var normal := collision_info.get_normal()
			
			if collider is TileMapLayer:
				hit_tile.emit(tile_to_hit, direction)
				direction = direction.bounce(normal)
			elif collider is BlockBreakerPlayer:
				hit_player.emit()
				## TODO: Not sure about this maths, seems fine though
				var delta_x :float =  position.x - collider.position.x
				delta_x = delta_x/(collider.width*16.0*0.5)
				delta_x = (delta_x/2) + 0.5
				var normal_angle: float = lerp(-paddle_normal_range, paddle_normal_range, delta_x)
				normal = Vector2.UP.rotated(deg_to_rad(normal_angle))
				direction = direction.bounce(normal)
				if direction.angle() > deg_to_rad(-10):
					direction = Vector2.from_angle(deg_to_rad(-10))
				if direction.angle() < deg_to_rad(-170):
					direction = Vector2.from_angle(deg_to_rad(-170))
				direction = direction.normalized()
