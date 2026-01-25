# Global game state

extends Node

signal energy_changed(int)
signal zoom_changed(value)
signal game_mode_changed(String)

signal quiz_requested(quiz_number: int)
signal challenge_requested()

var active_tile_type: String

const MAX_ENERGY: int = 999
const MIN_ENERGY: int = 0

var game_mode: String: set = set_game_mode
func set_game_mode(value: String) -> void:
	if value != "board" and value != "quiz" and value != "minigame":
		push_error("Invalid game_mode: " + value)
		return
	game_mode = value
	game_mode_changed.emit(game_mode)

var energy: int: set = set_energy
# Setter ενέργειας: εφαρμόζει clamp στα επιτρεπτά όρια και εκπέμπει signal μόνο όταν η τιμή αλλάζει πραγματικά
func set_energy(value: int):
	value = clamp(value, MIN_ENERGY, MAX_ENERGY)
	energy = value
	energy_changed.emit(energy)

var board_zoom_normalized: float: set = set_board_zoom_normalized
# Setter board zoom
func set_board_zoom_normalized(value: float):
	board_zoom_normalized = value
	zoom_changed.emit(board_zoom_normalized)

const TOTAL_QUIZZES: int = 38
var pending_quizzes: Array[int] = []
var answered_questions : int = 0
var challenges : int = 0

func _ready():
	reset_quiz_pool()

func reset_quiz_pool():
	pending_quizzes.clear()
	for i in range(1, TOTAL_QUIZZES + 1): pending_quizzes.append(i)
	pending_quizzes.shuffle()

func request_quiz():
	if (answered_questions * 0.1 >= challenges + 1) and (energy > 100):
		challenges += 1
		challenge_requested.emit()
		return
	if pending_quizzes.is_empty(): reset_quiz_pool()
	var quiz_num : int = pending_quizzes.pop_back()
	answered_questions += 1
	quiz_requested.emit(quiz_num)
