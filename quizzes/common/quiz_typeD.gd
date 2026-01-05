extends "res://quizzes/common/base_quiz.gd"

var _draggables: Array =[]

#αρχικοποιηση
func _ready():
	super()
	_draggables = get_tree().get_nodes_in_group("draggables")
	set_submit_button_enabled(true)

#υπολογισμος μέγιστης ενέργειας που θα μπορουσε να κερδισει ο παικτης
func calculate_max_energy() -> int:
	var max_energy : int = 0
	for d in _draggables:
		max_energy += d.energy_if_correct
	return max_energy

#υπολογισμος ενέργειας που κερδισε ο παικτης και εμφανηση του ποσου σε κάθε θεση υποδοχης που περιέχει απαντηση
func calculate_won_energy() -> int:
	var w_e: int = 0
	var zone = $Container/order_zone
	for i in range(zone.items.size()):
		var d = zone.items[i]
		var energy_won: int = 0
		energy_won = d.energy_if_correct + abs(i - d.correct_position) * d.energy_if_uncorrect
		var energy_label: Label = d.get_node("EnergyLabel")
		var s := ""; var c: Color
		if energy_won < 0: c = Color(0.8, 0, 0)
		elif energy_won > 0: c = Color(0, 0.8, 0); s = "+"
		else: c = Color(0.4, 0.4, 0.4)
		energy_label.add_theme_color_override("font_outline_color", c)
		energy_label.text = "⚡" + s + str(energy_won)
		w_e += energy_won
		_fade_in(d.get_node("EnergyLabel"))
	return w_e

# με το πάτημα του submit κελιδώνουν οι δυνατοτητες αλλαγων και τρεχει η γενικη συναρτηση στο baseQuiz
func _on_submit_pressed() -> void:
	for b in _draggables:
		b.mouse_filter = Control.MOUSE_FILTER_IGNORE
	super()
