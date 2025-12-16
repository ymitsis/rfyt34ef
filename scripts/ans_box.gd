extends TextureButton

@export var _energy_if_selected: int = 20
@export var _ans_text: String = "απάντηση (αλλάζει από editor/inspector )"

@onready var energy_label: Label = $EnergyLabel

var is_selected: bool = false

func _ready() -> void:
	$AnswerText.text = _ans_text
	energy_label.visible = false
	var s:= ""; var c: Color
	if _energy_if_selected < 0: c = Color(0.8, 0, 0)
	elif _energy_if_selected > 0: c = Color(0, 0.8, 0); s = "+"
	else: c = Color(0.4, 0.4, 0.4)
	energy_label.add_theme_color_override("font_outline_color", c)
	energy_label.text = "⚡" + s + str(_energy_if_selected)
	add_to_group("ans_boxes")
