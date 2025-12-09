extends Control

signal clicked(answer_box)

@export var _energy_if_selected: int = -20
@export var _ans_text: String = "Το κείμενο της απάντησης"
@export var _answer_image: Texture2D
@export var _shape_type: int = 1  # 1 = εξάγωνο, allo = ορθογώνιο
@export var _w_2: float = 100.0
@export var _h_2: float = 40.0


var is_selected: bool = false
var _points: PackedVector2Array = []
var _border_colors_selected: PackedColorArray = PackedColorArray()
var _border_colors_unselected: PackedColorArray = PackedColorArray()
var _fill_black_gradient: PackedColorArray = PackedColorArray()
var _fill_alpha: float = 1;
var _fill_if_selected: PackedColorArray = []
var _gradient_phase: float = 0.0
var _gradient_animating: bool = false



func _ready() -> void:
	connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	connect("mouse_exited", Callable(self, "_on_mouse_exited"))
	_set_energy_label()
	_set_answer_type()
	_border_colors_selected = _compute_loop_gradient_from_points(_points, Color(0.0, 0.8, 1.0), Color(0.0, 1.0, 0.8), 0)
	_border_colors_unselected = _transform_colors_hsv(_border_colors_selected, 0, 0.5, 0.9)
	
	
func _set_energy_label() -> void:
	var s:= ""; var c: Color
	$EnergyLabel.visible = false
	if _energy_if_selected < 0: c = Color(0.8, 0, 0)
	elif _energy_if_selected > 0: c = Color(0, 0.8, 0); s = "+"
	else: c = Color(0.4, 0.4, 0.4)
	$EnergyLabel.add_theme_color_override("font_outline_color", c)
	$EnergyLabel.text = "⚡" + s + str(_energy_if_selected)
	
	
func _set_answer_type() -> void:
	size = Vector2(2*_w_2, 2*_h_2)
	if _answer_image != null:
		$AnswerText.visible = false
		$AnswerImage.texture = _answer_image
		$AnswerImage.visible = true
		$AnswerImage.offset_left = 10
		$AnswerImage.offset_top = 10
		$AnswerImage.offset_right = -10
		$AnswerImage.offset_bottom = -10
		_fill_alpha = 0.5;
		_fill_if_selected = PackedColorArray([Color(0,0,0,0)])
	else:
		$AnswerImage.visible = false
		$AnswerText.text = _ans_text
		_fill_if_selected = PackedColorArray([Color(0,0,0)])
	if _shape_type == 1: _points = PackedVector2Array([Vector2(-_w_2, -_h_2), Vector2(_w_2, -_h_2), Vector2(_w_2 + 20, 0), Vector2(_w_2, _h_2), Vector2(-_w_2, _h_2), Vector2(-_w_2 - 20, 0)])
	else: _points = PackedVector2Array([Vector2(-_w_2, -_h_2), Vector2(_w_2, -_h_2), Vector2(_w_2, _h_2), Vector2(-_w_2, _h_2),])
	var center := get_rect().size * 0.5
	for i in range(_points.size()): _points[i] += center
	pivot_offset = center
	position = position - size * 0.5



func _compute_loop_gradient_from_points(points: PackedVector2Array,A: Color,B: Color,phase: float) -> PackedColorArray:
	var closed:=points.duplicate()
	closed.append(points[0])
	var cumulative:=PackedFloat32Array()
	cumulative.append(0.0)
	var total:=0.0
	for i in range(1,closed.size()):
		total+=closed[i].distance_to(closed[i-1])
		cumulative.append(total)
	var result:=PackedColorArray()
	for i in range(closed.size()):
		var t:=cumulative[i]/total
		t=fmod(t+phase,1.0)
		var w:=0.0
		if t<=0.5: w=t*2.0
		else: w=(1.0-t)*2.0
		result.append(A.lerp(B,w))
	return result


func _transform_colors_hsv(colors: PackedColorArray, hue_shift: float, saturation_factor: float, value_factor: float) -> PackedColorArray:
	var result := PackedColorArray()
	for c in colors:
		var h := c.h; var s := c.s; var v := c.v; var a := c.a
		h = h + hue_shift               
		s = s * saturation_factor       
		v = v * value_factor        
		if h < 0.0: h += 1.0
		if h >= 1.0: h -= 1.0
		s = clamp(s, 0.0, 1.0)
		v = clamp(v, 0.0, 1.0)
		var new_color := Color.from_hsv(h, s, v, a)
		result.append(new_color)
	return result


func _on_mouse_entered() -> void:
	_gradient_phase = 0.0
	_gradient_animating = true
	queue_redraw()


func _on_mouse_exited() -> void:
	_gradient_animating = false
	queue_redraw()


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		is_selected = !is_selected
		_gradient_animating = false
		emit_signal("clicked", self)
		queue_redraw()


func _process(delta: float) -> void:
	if !_gradient_animating: return
	_gradient_phase = fmod(_gradient_phase + 1 * delta, 1.0)
	_fill_black_gradient = _compute_loop_gradient_from_points(_points, Color(0.0, 0.0, 0.0, _fill_alpha), Color(0.3, 0.3, 0.3, _fill_alpha), _gradient_phase)
	queue_redraw()


func _draw() -> void:
	var border_width: float = 6
	var border_colors =_border_colors_unselected
	var fill = PackedColorArray([Color(0.3,0.3,0.3,_fill_alpha)])
	if is_selected:
		border_width = 10
		border_colors =_border_colors_selected
		fill = _fill_if_selected
	if _gradient_animating: fill = _fill_black_gradient
	var closed := _points.duplicate()
	closed.append(_points[0])
	draw_polygon(closed, fill)
	draw_polyline_colors(closed, border_colors, border_width, true)
