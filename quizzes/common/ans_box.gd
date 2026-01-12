# AnswerBox επιλογή απάντησης
# εκθέτει ιδιοτητες σε inspector και με βάση αυτες αποκτά μορφοποίηση.
# Μπαίνει στο group "ans_boxes" ώστε το quiz controller να μπορεί να βρίσκει/χειρίζεται όλα τα κουτιά απάντησης.
extends TextureButton

@export var _energy_if_selected: int = 20
@export var _ans_text: String = ""
@export var _auto_unpressed_img: bool = true
@export var _is_txt: bool = true

@onready var energy_label: Label = $EnergyLabel


var is_selected: bool = false

#φτιάχνει τη μορφοποιηση και το προσθέτει στο group "ans_boxes"
func _ready():
	$Txt_answer/Label.text = _ans_text
	var s:= ""; var c: Color
	if _energy_if_selected < 0: c = Color(0.8, 0, 0)
	elif _energy_if_selected > 0: c = Color(0, 0.8, 0); s = "+"
	else: c = Color(0.4, 0.4, 0.4)
	energy_label.visible = false
	energy_label.add_theme_color_override("font_outline_color", c)
	energy_label.text = "⚡" + s + str(_energy_if_selected)
	add_to_group("ans_boxes")
	if !_is_txt and !_auto_unpressed_img:
		$Low_contrast.visible = false
		$Boarder.visible = false
		$Txt_answer.visible = false
		return
	if _is_txt:
		$Low_contrast.visible = false
		$Txt_answer.visible = true
	else:
		$Txt_answer.visible = false
	toggled.connect(_on_toggled)
	_on_toggled(button_pressed)
	

func _on_toggled(toggled_on: bool) -> void:
	if _is_txt:
		$Txt_answer/Bg_black.visible = toggled_on
		$Boarder.visible = toggled_on
	elif _auto_unpressed_img:
		$Low_contrast.visible = !toggled_on
		$Boarder.visible = toggled_on
