# Tile node του board.
# Αντιπροσωπεύει ένα tile του χάρτη
# Κρατάει πληροφορία για το αν είναι active / clickable / visited και της move_energy από το active προς αυτό
# την οπτική του κατάσταση (χρώμα, outline, label) με βάση το game state.
# Εκπέμπει signal όταν γίνεται click με σκοπό να ενημερώσει το board.
extends Area2D
class_name Tile

signal clicked(tile)

@onready var _polygon2D: Polygon2D = $Polygon2D
@onready var _line2D: Line2D = $Line2D
@onready var _label: Label = $Label

@export var tile_type: String = ""            
@export var neighbors: Array[Tile] = []   

var is_active: bool                 
var is_clickable: bool                
var move_energy: int                   
var _has_been_visited: bool           


# Επαναφέρει την κατάσταση του tile στην αρχική (πριν από οποιαδήποτε κίνηση)
func init():
	is_active = false; is_clickable = false; move_energy = 0
	_has_been_visited = false


# Ορίζει τα στοιχεία του tile με βάση τα σημεία του polygon2D και το εντάσει στο group tiles
func _ready():
	$CollisionPolygon2D.polygon = _polygon2D.polygon
	_line2D.points = _polygon2D.polygon
	add_to_group("tiles")
	init()


# Διαχειρίζεται click input στο tile και εκπέμπει signal μόνο αν είναι clickable
func _input_event(_viewport, event, _shape_idx) -> void:
	if not is_clickable: return
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		emit_signal("clicked", self)


# Μετατρέπει την τιμή move_energy σε κείμενο για εμφάνιση στο tile
func _cost_to_string() -> String:
	if move_energy == 0: return ""
	var sng := "+" if move_energy > 0 else ""
	if is_clickable: return "⚡%s%dPJ" % [sng, move_energy]
	return "(⚡%s%dPJ)" % [sng, move_energy]


# Ενημερώνει την οπτική κατάσταση του tile (χρώμα, label, visited state) με tweens
func update_visual():
	if is_active: _has_been_visited = true
	var new_color : Color
	if is_active: new_color = Color(0.5, 0.5, 0.5, 0)     
	elif _has_been_visited: new_color = Color(0.5, 0.5, 0.5, 0)          
	elif is_clickable: new_color = Color(0.5, 0.5, 0.5, 0.7)               
	else: new_color = Color(0.5, 0.5, 0.5, 0.8)  
	var tween_poly := create_tween()
	tween_poly.tween_property(_polygon2D, "color", new_color, 1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	var tween_label := create_tween()
	tween_label.tween_property(_label, "modulate", Color(1, 1, 1, 0), 1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween_label.tween_callback(_update_label_text_and_color)
	tween_label.tween_property(_label, "modulate", Color(1, 1, 1, 1), 1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func _update_label_text_and_color() -> void:
	_label.text = _cost_to_string()
	if move_energy < 0: _label.add_theme_color_override("font_color", Color(1, 0.3, 0.3))
	else: _label.add_theme_color_override("font_color", Color(0.3, 1, 0.3))


# Οπτική ανάδειξη του tile στο hover
func _on_mouse_entered():
	if not is_clickable: return
	_line2D.width = 5
	_line2D.default_color = Color(1.0, 1.0, 0.0, 0.8)
# Τέλος οπτικής ανάδειξης του tile στο hover
func _on_mouse_exited():
	_line2D.width = 3
	_line2D.default_color = Color(1.0, 1.0, 0.0, 0.3)
