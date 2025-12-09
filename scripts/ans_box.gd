extends TextureButton

signal clicked(answer_box)

@export var _energy_if_selected: int = 20
@export var _ans_text: String = "απάντηση (αλλάζει από editor/inspector )"


var is_selected: bool = false


func _ready() -> void:
	$AnswerText.text = _ans_text
	$EnergyLabel.visible = false
	var s:= ""; var c: Color
	if _energy_if_selected < 0: c = Color(0.8, 0, 0)
	elif _energy_if_selected > 0: c = Color(0, 0.8, 0); s = "+"
	else: c = Color(0.4, 0.4, 0.4)
	$EnergyLabel.add_theme_color_override("font_outline_color", c)
	$EnergyLabel.text = "⚡" + s + str(_energy_if_selected)
	add_to_group("ans_boxes")


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		emit_signal("clicked", self)
