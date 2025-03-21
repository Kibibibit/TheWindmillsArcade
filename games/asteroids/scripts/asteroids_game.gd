extends Node2D
class_name AsteroidsGame


@export_category("Colors")
@export var background_color: Color
@export var star_color: Color
@export_category("Entities")
@export var player: AsteroidsPlayer
@export var entities_parent: Node2D
@export var bullet_packed_scene: PackedScene
@export var asteroid_packed_scene: PackedScene
@export_category("UI")
@export var floating_text_parent: FloatingTextParent
@export var score_label: Label

@onready
var screen_width: float = get_viewport_rect().size.x
@onready
var screen_height: float = get_viewport_rect().size.y

var timer: float = 0.0

var score: int = 0

var asteroid_count: int = 0
func _ready() -> void:
	player.shoot.connect(_spawn_bullet)

func _process(delta: float) -> void:
	timer -= delta
	if timer <= 0 && asteroid_count < 200:
		timer = randf_range(1.0,4.0)
		var spawn_count: int = randi_range(1, 4)
		for _x in spawn_count:
			var spawn_pos: Vector2 = Vector2(randf_range(0, screen_width), randf_range(0, screen_height))
			var size: int = randi_range(0,2)
			var new_asteroid: AsteroidsAsteroid = asteroid_packed_scene.instantiate()
			new_asteroid.size = size
			new_asteroid.global_position = to_global(spawn_pos)
			new_asteroid.game_scene = self
			new_asteroid.velocity = Vector2.from_angle(randf()*2.0*PI) * randf_range(AsteroidsAsteroid.MIN_SPEED,AsteroidsAsteroid.MAX_SPEED)
			entities_parent.add_child(new_asteroid)
	
	score_label.text = "Score: %d" % score

func add_score(_score: int, pos: Vector2):
	score += _score
	floating_text_parent.display_text("+%d" % _score, pos)

func _spawn_bullet(pos: Vector2, velocity: Vector2):
	var bullet: AsteroidsBullet = bullet_packed_scene.instantiate()
	bullet.position = pos
	bullet.velocity = velocity
	entities_parent.add_child(bullet)

func _draw() -> void:
	draw_rect(get_viewport_rect(), background_color)
