extends Control

var is_locked: bool = false

@export var full_img: Texture2D
@export var cols: int = 4
@export var rows: int = 3
@export var energy_if_correct: int = 4
@export var swap_tile_scene: PackedScene


var _tiles: Array[SwapTile] = []
var _slot_positions: Array[Vector2] = []
var _selected_tile_index: int = -1

var swap_count: int = 0
var correct_tiles_count: int:
	get:
		var c := 0
		for i in range(_tiles.size()):
			if _tiles[i].position == _slot_positions[i]:
				c += 1
		return c

func _ready() -> void:
	swap_count = 0
	_create_tiles()
	_shuffle_tiles()

func _create_tiles() -> void:
	var tile_size := Vector2(size.x / float(cols), size.y / float(rows))
	var tex_size: Vector2 = full_img.get_size()
	var region_size := Vector2(tex_size.x / float(cols), tex_size.y / float(rows))
	var tile_index := 0
	for row in range(rows):
		for col in range(cols):
			var pos := Vector2(col * tile_size.x, row * tile_size.y)
			_slot_positions.append(pos)
			var tile := swap_tile_scene.instantiate() as SwapTile
			tile.tile_index = tile_index
			tile.position = pos
			tile.size = tile_size
			var region_rect := Rect2(col * region_size.x, row * region_size.y, region_size.x, region_size.y)
			var atlas := AtlasTexture.new()
			atlas.atlas = full_img
			atlas.region = region_rect
			tile.texture = atlas
			add_child(tile)
			_tiles.append(tile)
			tile.clicked.connect(_on_tile_clicked)
			tile_index += 1

func _shuffle_tiles() -> void:
	var shuffled_positions := _slot_positions.duplicate()
	shuffled_positions.shuffle()
	for i in range(_tiles.size()):
		_tiles[i].position = shuffled_positions[i]

func _on_tile_clicked(tile: SwapTile) -> void:
	if is_locked: return
	var tile_index := tile.tile_index
	if _selected_tile_index == -1:
		_selected_tile_index = tile_index
		_tiles[_selected_tile_index].is_selected = true
		_tiles[_selected_tile_index].move_to_front()
		return
	if _selected_tile_index == tile_index:
		_tiles[_selected_tile_index].is_selected = false
		_selected_tile_index = -1
		return
	_swap_tiles(_selected_tile_index, tile_index)
	swap_count += 1

func _swap_tiles(a: int, b: int) -> void:
	is_locked = true
	var pos_a := _tiles[a].position
	var pos_b := _tiles[b].position
	_tiles[b].move_to_front()
	_tiles[a].move_to_front()
	var tw := create_tween()
	tw.set_trans(Tween.TRANS_BACK)
	tw.set_ease(Tween.EASE_OUT)
	tw.set_parallel(true)
	tw.tween_property(_tiles[a], "position", pos_b, 1)
	tw.tween_property(_tiles[b], "position", pos_a, 1)
	tw.set_parallel(false)
	tw.tween_callback(func():
		_tiles[a].is_selected = false
		_selected_tile_index = -1
		is_locked = false
	)

func reveal_result() -> void:
	is_locked = true
	_selected_tile_index = -1
	for i in range(_tiles.size()):
		var correct := _tiles[i].position == _slot_positions[i]
		_tiles[i].is_selected = false
		_tiles[i].show_border = false
		_tiles[i].set_dimmed(not correct)
		_tiles[i].set_locked(true)
