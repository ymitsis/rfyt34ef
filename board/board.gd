# Board controller.
# Διαχειρίζεται τον χάρτη του παιχνιδιού, το ενεργό tile, το κόστος μετακίνησης
# και τη λογική μετάβασης του παίκτη μεταξύ tiles με βάση την ενέργεια.
extends Node2D

@onready var _camera: Camera2D = $Camera2D
@onready var _player: Player = $Player
@onready var _tiles: Array = get_tree().get_nodes_in_group("tiles")

var _active_tile: Tile
var _zoom_tween: Tween


# Αρχικοποιεί το board: ορίζει αρχικό tile, παίκτη, κάμερα και tiles
func init():
	_active_tile = get_node("A01")
	GameState.active_tile_type = "A"
	_camera.global_position = _active_tile.global_position
	_player.global_position = _active_tile.global_position
	_player.init()
	for t in _tiles: t.init()
	update_tiles_state()
	GameState.energy_changed.connect(_on_energy_changed)


# Συνδέει τα click signals όλων των tiles
func _ready():
	for t in _tiles: t.clicked.connect(_on_tile_clicked)
	GameState.zoom_changed.connect(_on_zoom_changed)

func _on_energy_changed(_value):
	update_tiles_state()

# κάνει zoom την κάμερα του board με smooth τροπο
func _on_zoom_changed(value):
	var min_zoom := (get_window().size.y * 0.98) / 2000.0
	value = lerp(min_zoom, max(min_zoom, 1.0), value)
	if _zoom_tween: _zoom_tween.kill()
	_zoom_tween = create_tween()
	_zoom_tween.tween_property(_camera,"zoom",Vector2(value, value), 1.0).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)

# Χειρίζεται click σε clickabe tile και ξεκινά τη μετακίνηση του παίκτη
func _on_tile_clicked(tile: Tile):
	if _player.is_moving: return
	_active_tile = tile
	GameState.energy += tile.move_energy
	GameState.active_tile_type = tile.tile_type
	_camera.global_position = _active_tile.global_position
	_player.new_target = _active_tile.global_position

# Υπολογίζει το ενεργειακό κόστος μετάβασης μεταξύ δύο τύπων tiles
func get_move_energy(from_type: String, to_type: String) -> int:
	if from_type == "A" and to_type == "B": return -50
	if from_type == "B" and to_type == "A": return 20
	if from_type == "B" and to_type == "C": return -100
	if from_type == "C" and to_type == "B": return 40
	if from_type == "C" and to_type == "D": return -200
	if from_type == "D" and to_type == "C": return 80
	if from_type == to_type: return -20
	return 0

# Ενημερώνει την κατάσταση όλων των tiles (active, clickable, κόστος, visuals)
func update_tiles_state():
	var no_clickable_tiles = true
	for t in _tiles:
		t.is_clickable = false; t.move_energy = 0;
		t.is_active = (t == _active_tile)
		if t in _active_tile.neighbors:
			t.move_energy = get_move_energy(_active_tile.tile_type, t.tile_type)
			t.is_clickable = (GameState.energy + t.move_energy >= 0)
			if t.is_clickable: no_clickable_tiles = false
		t.update_visual()
	if no_clickable_tiles:
		await get_tree().create_timer(2.0).timeout
		get_tree().change_scene_to_file("res://final/final_lose.tscn")
