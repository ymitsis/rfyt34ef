# quiz τυπου C περιλαμβανει ένα mini game όπου μια εικονα κοβεται σε κομματια και ο παικτης εναλλασει τα κομματια για να την φτιαξει
extends "res://scripts/base_quiz.gd"

@onready var _swap_puzzle: Control = $Container/SwapPuzzle

#αρχικοποιηση 
func _ready():
	super()
	set_submit_button_enabled(true)

# επειδη δεν ειναι ευκολο να υπολογστει ο ελαχιστος αριθμος εναλλαγων για να τακτοποιηθει η εικονα 
# παιρνουε την ιδανικη περιπτωση (πρακτικα ομως αδυνατη) που δεν χρειαζεται καμια εναλλαγη
func calculate_max_energy() -> int:
	return _swap_puzzle.correct_tiles_count * 4

# υπολογισμος ενεργειας που κερδιθηκε. Αφαιρειται 1 ποντος για κάθε εναλλαγη
func calculate_won_energy() -> int:
	var w_e: int = 0
	w_e = _swap_puzzle.correct_tiles_count * 4
	w_e = w_e - _swap_puzzle.swap_count
	return w_e

# η εικονα αποκαλυπτεται και τρεχει η γενικη συναρτηση στο baseQuiz
func _on_submit_pressed() -> void:
	if _swap_puzzle.is_locked: return
	_swap_puzzle.reveal_result()
	super()
