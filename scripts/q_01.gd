extends "res://scripts/base_quiz.gd"

@export var is_multiselect: bool = true

var _ans_btn_group := ButtonGroup.new() 

func _ready():
	super()
	if !is_multiselect:
		_ans_btn_group.allow_unpress = true
		for b in get_tree().get_nodes_in_group("ans_boxes"):
			b.button_group = _ans_btn_group
	for b in get_tree().get_nodes_in_group("ans_boxes"):
		b.toggled.connect(_on_answer_toggled)
	_update_submit_enabled()

func _has_any_pressed() -> bool:
	for b in get_tree().get_nodes_in_group("ans_boxes"):
		if b.button_pressed: return true
	return false
	
func _on_answer_toggled(_pressed: bool) -> void:
	_update_submit_enabled()

func _update_submit_enabled() -> void:
	var has_pressed := false
	for b in get_tree().get_nodes_in_group("ans_boxes"):
		if b.button_pressed: has_pressed = true
	$Container/submit.disabled = not has_pressed
	if $Container/submit.disabled: $Container/submit.mouse_default_cursor_shape = Control.CURSOR_ARROW
	else: $Container/submit.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

func calculate_max_energy() -> int:
	var max_energy : int = 0
	for b in get_tree().get_nodes_in_group("ans_boxes"):
		if b._energy_if_selected > 0:
			max_energy += b._energy_if_selected
	return max_energy
	
func calculate_won_energy() -> int:
	var w_e: int = 0
	for b in get_tree().get_nodes_in_group("ans_boxes"):
		if b.button_pressed:
			w_e += b._energy_if_selected
			_fade_in(b.get_node("EnergyLabel"))
	return w_e

func _on_submit_pressed() -> void:
	for b in get_tree().get_nodes_in_group("ans_boxes"):
		b.mouse_filter = Control.MOUSE_FILTER_IGNORE
	super()
