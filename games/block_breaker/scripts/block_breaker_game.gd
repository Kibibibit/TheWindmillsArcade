extends Node2D
class_name BlockBreakerGame


enum GameState {SERVING, PLAYING, DEAD}

const TILE_ATLAS_DATA : Dictionary[int, Vector2i] = {
	0: Vector2i(0,2),
	1: Vector2i(1,2),
	2: Vector2i(2,2),
	3: Vector2i(3,2),
	4: Vector2i(0,3),
	5: Vector2i(1,3),
	6: Vector2i(2,3),
	7: Vector2i(3,3)
}
const COLORS: Array[Color] = [Color.PALE_GREEN, Color.AQUA, Color.YELLOW, Color.HOT_PINK]
const BLOCK_SCORES: Array[int] = [100,150,200,300]


@export_category("Tiles")
@export var foreground_tiles: TileMapLayer
@export_category("Entities")
@export var player: BlockBreakerPlayer
@export var ball: BlockBreakerBall
@export var particle_parent: Node2D
@export_category("Particles")
@export var flash_particle: PackedScene
@export_category("Sound")
@export var audio_player: AudioPlayer
@export_category("UI")
@export var floating_text_parent: FloatingTextParent
@export var score_display: Label


var score: int = 0
var score_mult: float = 1.0

var state: GameState = GameState.SERVING

func _ready() -> void:
	ball.hit_tile.connect(_ball_hit)
	ball.hit_player.connect(_player_hit)

func _process(_delta: float) -> void:
	match state:
		GameState.SERVING:
			_run_serving()
		GameState.PLAYING:
			_run_playing()
		GameState.DEAD:
			pass


func _run_serving() -> void:
	ball.position.x = player.position.x
	ball.position.y = player.position.y - 13
	
	if Input.is_action_just_pressed("ui_accept"):
		state = GameState.PLAYING
		ball.moving = true
		ball.direction.x = [-1,1].pick_random()
		ball.direction = ball.direction.normalized()
		return

func _run_playing() -> void:
	score_display.text = "Score: %d\nMultiplier: x%d" % [score, score_mult]


func _ball_hit(tile_coords: Vector2i, _ball_direction: Vector2) -> void:
	var tile_data : TileData = foreground_tiles.get_cell_tile_data(tile_coords)
	
	if tile_data == null:
		## This is a naive approach to the fix, probably better solutions possible
		print("Got null data")
		for x in range(-1,2):
			for y in range(-1,2):
				tile_data = foreground_tiles.get_cell_tile_data(tile_coords + Vector2i(x,y))
				tile_coords = tile_coords + Vector2i(x,y)
				print(tile_data, tile_data != null)
				if tile_data != null:
					#foreground_tiles.set_cell(tile_coords+ Vector2i(x,y), 0, Vector2i(2,1))
					break
			if tile_data != null:
				break
		print("Tried alternatives")
	
	if tile_data != null:
		var tile_type : int = tile_data.get_custom_data("tile_type")
		if tile_type < 0:
			audio_player.play_sound(&"bounce_wall")
			if player.position.y < ball.position.y:
				audio_player.play_sound(&"game_over")
				ball.moving = false
				state = GameState.DEAD
				return
		else:
			var block_broken: bool = false
			var other := Vector2i(1, 0)
			var other_index : int = 1
			var other_offset: int = 0
			if tile_type % 2 > 0:
				other = Vector2i(-1,0)
				other_index = -1
				other_offset = -16
			if tile_type - 2 < 0:
				foreground_tiles.erase_cell(tile_coords)
				foreground_tiles.erase_cell(tile_coords+other)
				audio_player.play_sound([
					&"block_break_a",
					&"block_break_b",
					&"block_break_c"
					
				].pick_random())
				block_broken = true
			else:
				audio_player.play_sound(&"block_shield")
				foreground_tiles.set_cell(tile_coords, 0, TILE_ATLAS_DATA[tile_type-2])
				foreground_tiles.set_cell(tile_coords+other, 0, TILE_ATLAS_DATA[tile_type-2+other_index])
			_spawn_particles(tile_coords, other_offset, block_broken)
			var tile_index: int = floori((tile_type as float)/2.0)
			var delta_score : int = floori(BLOCK_SCORES[tile_index]*score_mult)
			score += delta_score
			
			floating_text_parent.display_text("+%d (x%d)" % [delta_score, score_mult], tile_coords*16, COLORS[tile_index])
			
			if block_broken:
				score_mult += 1
	else:
		## TODO: Solve this 
		print("Missed! ", tile_coords)
		foreground_tiles.set_cell(tile_coords, 0, Vector2i(2,1))
func _player_hit() -> void:
	audio_player.play_sound(&"bounce_paddle")
	score_mult = 1

func _spawn_particles(tile_coords: Vector2i, offset: int, broke: bool) -> void:
	var flash : BlockBreakerFlash = flash_particle.instantiate()
	particle_parent.add_child(flash)
	flash.position = tile_coords*16
	flash.position.x += offset
	
	if broke:
	
		var chunk_a := BlockBreakerChunk.new(-1, false)
		
		particle_parent.add_child(chunk_a)
		chunk_a.position = flash.position+Vector2(8,8)
		var chunk_b := BlockBreakerChunk.new(1, true)
		
		particle_parent.add_child(chunk_b)
		chunk_b.position = chunk_a.position + Vector2(16,0)
