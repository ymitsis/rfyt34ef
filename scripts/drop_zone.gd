extends Control

signal drop_zone_change

@onready var energy_lbl: Label = $EnergyLabel

@export var storage: Control
@export var energy_if_correct: int = 4
@export var energy_if_uncorrect: int = -1
@export var energy_if_nothing: int = 0
@export var correct_dgaggable: Control

var energy_won: int = 0
var has_draggable: bool


func _ready() -> void:
	energy_lbl.visible = false
	_on_child_order_changed()
	add_to_group("drop_zones")

func _on_child_order_changed() -> void:
	if !is_inside_tree(): return
	var ans: Control = _find_draggable_item()
	has_draggable = ans != null
	if ans == correct_dgaggable: energy_won = energy_if_correct
	elif ans == null: energy_won = energy_if_nothing
	else: energy_won = energy_if_uncorrect
	var s := ""; var c: Color
	if energy_won < 0: c = Color(0.8, 0, 0)
	elif energy_won > 0: c = Color(0, 0.8, 0); s = "+"
	else: c = Color(0.4, 0.4, 0.4)
	energy_lbl.add_theme_color_override("font_outline_color", c)
	if ans == null and energy_if_nothing == 0: energy_lbl.text = ""
	else: energy_lbl.text = "⚡" + s + str(energy_won)
	emit_signal("drop_zone_change")

func _can_drop_data(_at_position: Vector2, _data: Variant) -> bool:
	return true

func _find_draggable_item() -> Control:
	for child in get_children():
		if child.is_in_group("draggables"):
			return child
	return null

func _store_item(ctrl: Control) -> void:
	var from := ctrl.global_position
	remove_child(ctrl)
	storage.add_child(ctrl)
	await get_tree().process_frame
	ctrl.global_position = from
	_slide_to(ctrl, ctrl.home_position)

func _place_item(ctrl: Control, drop_pos: Vector2, final_pos: Vector2, grab_offset: Vector2) -> void:
	ctrl.get_parent().remove_child(ctrl)
	add_child(ctrl)
	await get_tree().process_frame
	ctrl.position = drop_pos - grab_offset
	_slide_to(ctrl, final_pos)

func _drop_data(at_position: Vector2, data: Variant) -> void:
	var ctrl: Control = data["drag_obj"]
	if ctrl.get_parent() == self: return
	var grab_offset: Vector2 = data.get("grab_offset", ctrl.size * 0.5)
	if storage == null:
		await _place_item(ctrl, at_position, ctrl.home_position, grab_offset)
		return
	var to_store := _find_draggable_item()
	if to_store: await _store_item(to_store)
	var center := (size - ctrl.size) * 0.5
	await _place_item(ctrl, at_position, center, grab_offset)

func _slide_to(ctrl: Control, target: Vector2, duration := 0.5) -> void:
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(ctrl, "position", target, duration)
