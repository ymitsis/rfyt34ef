extends Control

#const BASE_SIZE := Vector2(200, 200)

var _step: int = 100
var _current_value: int = 0
var _current_value_f: float = 0.0
var _target_value: int

@onready var _mask: Polygon2D = $gauge_colors/mask
@onready var _value: Label = $labels_container/value_lbl


#Συνδεση σε sigmal resize και energychange
func _ready() -> void:
	GameState.energy_changed.connect(_on_energy_changed)

#ζωγραφια του gauge αναλογα με την τιμη που πρεπει να απεικονιζει
func draw_gauge(value: float) -> void:
	var t: float = value / GameState.MAX_ENERGY
	var theta: float = lerp(-220.0, 40.0, t)
	const POLY_EDGES: int = 15
	const RADIUS: float = 100.0
	var start_rad: float = deg_to_rad(theta)
	var end_rad: float = deg_to_rad(40.0)
	var pts: Array = [Vector2.ZERO]
	for i in range(POLY_EDGES + 1):
		var seg_t: float = float(i) / POLY_EDGES
		var ang: float = lerp(start_rad, end_rad, seg_t)
		pts.append(Vector2(cos(ang), sin(ang)) * RADIUS)
	_mask.polygon = pts
	_value.text = str(int(value))

#ξεκιναει η smooth διαδικασία επεικονισης της νέας τιμης ενέργειας
func _on_energy_changed(value: int) -> void:
	_target_value = value
	_current_value_f = float(_current_value)
	set_process(true)

#smoth διαδικασια μεταβολης ενέργειας
func _process(delta: float) -> void:
	var target_f: float = float(_target_value)
	_current_value_f = move_toward(_current_value_f, target_f, float(_step) * delta)
	_current_value = int(_current_value_f)
	if is_equal_approx(_current_value_f, target_f):
		_current_value_f = target_f
		_current_value = _target_value
		set_process(false)
	draw_gauge(_current_value_f)
