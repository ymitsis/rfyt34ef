extends Node2D

var _active_tile = Node2D

func init_board() -> void:
	_active_tile = get_node("B01")
	$Camera2D.global_position = _active_tile.global_position
	$Player1.global_position = _active_tile.global_position
	$Player1.init_player()
	for t in get_tree().get_nodes_in_group("tiles"): t.init_tile()
	_update_tiles_state()


func _ready() -> void:
	for t in get_tree().get_nodes_in_group("tiles"): t.clicked.connect(_on_tile_clicked)


func _on_tile_clicked(tile) -> void:
	if $Player1.is_moving: return
	GameState.energy -= tile.move_cost
	print("energy:", GameState.energy)
	_active_tile = tile
	_update_tiles_state()
	$Camera2D.global_position = _active_tile.global_position
	$Player1.new_target = _active_tile.global_position


func _get_move_cost(from_type: String, to_type: String) -> int:
	if from_type > to_type: return 0
	if from_type == to_type: return 20
	if from_type == "A" and to_type == "B": return 50
	if from_type == "B" and to_type == "C": return 100
	if from_type == "C" and to_type == "D": return 200
	return -1


func _update_tiles_state() -> void:
	for t in get_tree().get_nodes_in_group("tiles"):
		t.is_clickable = false; t.move_cost = -1;
		t.is_active = (t == _active_tile)
		if t in _active_tile.neighbors:
			t.move_cost = _get_move_cost(_active_tile.tile_type, t.tile_type)
			t.is_clickable = t.move_cost <= GameState.energy
		t.update_visual()
