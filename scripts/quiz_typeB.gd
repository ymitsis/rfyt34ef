extends "res://scripts/base_quiz.gd"


func _ready():
	super()
	for b in get_tree().get_nodes_in_group("drop_zones"):
		b.drop_zone_change.connect(_on_drop_zone_change)
	_update_submit_enabled()
	
func _on_drop_zone_change() -> void:
	_update_submit_enabled()

func _update_submit_enabled() -> void:
	var has_draggables := false
	for b in get_tree().get_nodes_in_group("drop_zones"):
		if b.storage != null and b.has_draggable: has_draggables = true
	set_submit_button_enabled(has_draggables)

func calculate_max_energy() -> int:
	var max_energy : int = 0
	for b in get_tree().get_nodes_in_group("drop_zones"):
		if b.storage != null:
			max_energy += b.energy_if_correct
	return max_energy
	
func calculate_won_energy() -> int:
	var w_e: int = 0
	for b in get_tree().get_nodes_in_group("drop_zones"):
		if b.storage != null:
			w_e += b.energy_won
			_fade_in(b.get_node("EnergyLabel"))
	return w_e

func _on_submit_pressed() -> void:
	for b in get_tree().get_nodes_in_group("draggables"):
		b.mouse_filter = Control.MOUSE_FILTER_IGNORE
	super()
