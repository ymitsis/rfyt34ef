extends Control

#const BASE_SIZE := Vector2(200, 200)

var _step: int = 100
var _current_value: int = 0
var _current_value_f: float = 0.0
var _target_value: int

@onready var _scaler : Control = $Scaler
@onready var _mask: Polygon2D = $Scaler/gauge2/mask
@onready var _gauge3: TextureRect = $Scaler/gauge1/gauge3
@onready var _value: Label = $Scaler/labels_container/value_lbl


#Συνδεση σε sigmal resize και energychange
func _ready() -> void:
	GameState.energy_changed.connect(_on_energy_changed)
	resized.connect(_update_scaler)
	_update_scaler()  

#προσαρμοζει το μέγεθος του gauge στο μεγεθος του γονέα
func _update_scaler():
	var parent_size := size
	var base_size : Vector2 = _scaler.size
	var s: float = min(parent_size.x / base_size.x, parent_size.y / base_size.y)
	_scaler.scale = Vector2(s, s)
	_scaler.position = Vector2((parent_size.x - base_size.x * _scaler.scale.x) * 0.5, 0.0)



#ζωγραφια του gauge αναλογα με την τιμη που πρεπει να απεικονιζει
func draw_gauge(value: float) -> void:
	var t: float = value / GameState.MAX_ENERGY
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
	_gauge3.position = pts[1] * 0.85 - _gauge3.size * 0.5 + Vector2(100, 100)
	var h: float = lerp(0.0, 0.333, t)
	_gauge3.modulate = Color.from_hsv(h, 1, 0.8, 1.0)
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
