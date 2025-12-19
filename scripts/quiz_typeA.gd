# Quiz τυπου Α ειναι το κλασικο multiple choice. 
# με δυνατοτητες επιλογης εικονων (αντι μονο κειμενου) και >1 επιλογές
extends "res://scripts/base_quiz.gd"

@export var is_multiselect: bool = true

var _ans_btn_group := ButtonGroup.new()
var _ans_boxes: Array = []

#αρχικοποιηση αναλογα με το αν ειανι μονης ή πολλαπλης επιλογης. Συνδεση με signal πατηματος απαντησης.
func _ready():
	super()
	_ans_boxes = get_tree().get_nodes_in_group("ans_boxes")
	if !is_multiselect:
		_ans_btn_group.allow_unpress = true
		for b in _ans_boxes:
			b.button_group = _ans_btn_group
	for b in _ans_boxes:
		b.toggled.connect(_on_answer_toggled)
	_update_submit_enabled()

#οταν επιλέγεται/αποεπιλεγεται μια απαντηση πιθανον να πρέπει να αλλαξει μορφη το submit
func _on_answer_toggled(_pressed: bool):
	_update_submit_enabled()

#Αν δεν εχει επιλεγει καμια απάντηση, το submit ειναι disabled
func _update_submit_enabled():
	var has_pressed := false
	for b in _ans_boxes:
		if b.button_pressed: has_pressed = true
	set_submit_button_enabled(has_pressed)

#υπολογισμος μέγιστης ενέργειας που θα μπορουσε να κερδισει ο παικτης
func calculate_max_energy() -> int:
	var max_energy : int = 0
	for b in _ans_boxes:
		if b._energy_if_selected > 0:
			max_energy += b._energy_if_selected
	return max_energy

#υπολογισμος ενέργειας που κερδισε ο παικτης και εμφανηση του ποσου σε κάθε απάντηση από τις επιλεγμενες
func calculate_won_energy() -> int:
	var w_e: int = 0
	for b in _ans_boxes:
		if b.button_pressed:
			w_e += b._energy_if_selected
			_fade_in(b.get_node("EnergyLabel"))
	return w_e

# με το πάτημα του submit κελιδώνουν οι δυνατοτητες αλλαγων και τρεχει η γενικη συναρτηση στο baseQuiz
func _on_submit_pressed() -> void:
	for b in _ans_boxes:
		b.mouse_filter = Control.MOUSE_FILTER_IGNORE
	super()
