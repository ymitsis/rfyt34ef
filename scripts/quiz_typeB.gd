# Quiz τυπου B εχει θέσης υποδοχης drag/drop αντικειμενων. Τα αντικειμενα αρχικά ειναι σε θέση υποδοχης storage
# Τα draggable ειναι κενα αντικειμενα οπότε πρέπει να έχουν παιδια εικονες ή κειμενο.
# Οι θεσεις υποδοχης δέχονται 1 αντικειμενο εκτος αν δεν έχει δηλωθει storage για την θέση αυτη, οπότε storage νοηται η θέση αυτη
extends "res://scripts/base_quiz.gd"

var _drop_zones: Array = []

#αρχικοποιηση. Συνδεση με event υποδοχης απάντησης
func _ready():
	super()
	_drop_zones = get_tree().get_nodes_in_group("drop_zones")
	for b in _drop_zones:
		b.drop_zone_change.connect(_on_drop_zone_change)
	_update_submit_enabled()

#οταν στις θέσεις υποδοχης κάτι ερχεται/φευγει, πιθανον να πρέπει να αλλαξει μορφη το submit
func _on_drop_zone_change():
	_update_submit_enabled()

#Αν ολες οι θέσεις υποδοχης είναι κενες, το submit ειναι disabled
func _update_submit_enabled():
	var has_draggables := false
	for b in _drop_zones:
		if b.storage != null and b.has_draggable: has_draggables = true
	set_submit_button_enabled(has_draggables)

#υπολογισμος μέγιστης ενέργειας που θα μπορουσε να κερδισει ο παικτης
func calculate_max_energy() -> int:
	var max_energy : int = 0
	for b in _drop_zones:
		if b.storage != null:
			max_energy += b.energy_if_correct
	return max_energy

#υπολογισμος ενέργειας που κερδισε ο παικτης και εμφανηση του ποσου σε κάθε θεση υποδοχης που περιέχει απαντηση
func calculate_won_energy() -> int:
	var w_e: int = 0
	for b in _drop_zones:
		if b.storage != null:
			w_e += b.energy_won
			_fade_in(b.get_node("EnergyLabel"))
	return w_e

# με το πάτημα του submit κελιδώνουν οι δυνατοτητες αλλαγων και τρεχει η γενικη συναρτηση στο baseQuiz
func _on_submit_pressed() -> void:
	for b in get_tree().get_nodes_in_group("draggables"):
		b.mouse_filter = Control.MOUSE_FILTER_IGNORE
	super()
