extends Node2D

func _init_main() -> void:
	GameState.energy = 400
	$Board.init_board()


func _ready() -> void:
	_init_main()
