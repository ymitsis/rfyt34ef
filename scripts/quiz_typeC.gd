extends "res://scripts/base_quiz.gd"

@onready var _swap_puzzle: Control = $Container/SwapPuzzle

func _ready():
	super()
	set_submit_button_enabled(true)

func calculate_max_energy() -> int:
	return 48

func calculate_won_energy() -> int:
	var w_e: int = 0
	w_e = _swap_puzzle.correct_tiles_count * 4
	w_e = w_e - _swap_puzzle.swap_count
	return w_e

func _on_submit_pressed() -> void:
	if _swap_puzzle.is_locked: return
	_swap_puzzle.reveal_result()
	super()
