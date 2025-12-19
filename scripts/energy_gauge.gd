extends Control

var _step: int = 1
var _current_value: int
var _target_value: int

@onready var _mask: Polygon2D = $mask
@onready var _gauge3: Sprite2D = $gauge3
@onready var _value: Label = $value


func init_gauge() -> void:
	_current_value = 0

func _ready() -> void:
	GameState.energy_changed.connect(_on_energy_changed)
	init_gauge()  # προσορινο. Κανονια πρέπει init στην init του UI

func draw_gauge(value: int) -> void:
	var t: float = float(value) / GameState.MAX_ENERGY
	var theta: float = lerp(-220.0, 40.0, t)
	const POLY_EDGES: int = 15
	const RADIUS: float = 96.0
	var start_rad: float = deg_to_rad(theta)
	var end_rad: float = deg_to_rad(40.0)
	var pts: Array = [Vector2.ZERO]
	for i in range(POLY_EDGES + 1):
		var seg_t: float = float(i) / POLY_EDGES
		var ang: float = lerp(start_rad, end_rad, seg_t)
		pts.append(Vector2(cos(ang), sin(ang)) * RADIUS)
	_mask.polygon = pts
	_gauge3.position = pts[1] * 0.85
	var h: float = lerp(0.0, 0.333, t)
	_gauge3.modulate = Color.from_hsv(h, 1, 0.8, 1.0)
	_value.text = str(value)


func _on_energy_changed(value: int) -> void:
	_target_value = value
	set_process(true)


func _process(_delta: float) -> void:
	if _current_value == _target_value:
		set_process(false)
		return
	_current_value += int(sign(_target_value - _current_value)) * _step
	if abs(_target_value - _current_value) < _step: _current_value = _target_value
	draw_gauge(_current_value)
