extends Sprite2D
class_name BlockBreakerChunk

const CHUNK_SPEED :float = 150.0

var sprite : CompressedTexture2D = preload("res://games/block_breaker/assets/block_chunks.png")

var velocity := Vector2(0, 0)

var life_time: int = 60*6

func _init(x_dir: int, h_flip: bool) -> void:
	texture = sprite
	velocity = Vector2(x_dir, -1)*CHUNK_SPEED
	if h_flip:
		flip_h = true

func _process(delta: float) -> void:
	position += velocity*delta
	velocity.y += delta*900.0
	life_time -= 1
	
	if life_time < 0:
		self.get_parent().remove_child(self)
		self.queue_free()
