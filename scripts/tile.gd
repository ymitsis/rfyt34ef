extends Area2D

signal clicked(tile)

@export var tile_type: String = ""            
@export var neighbors: Array[Area2D] = []     

var is_active: bool                 
var is_clickable: bool                
var move_cost: int                   
var _has_been_visited: bool           

func init_tile() -> void:
	is_active = false; is_clickable = false; move_cost = -1
	_has_been_visited = false
	

func _ready() -> void:
	add_to_group("tiles")
	$CollisionPolygon2D.polygon = $Polygon2D.polygon
	$Line2D.points = $Polygon2D.polygon
	init_tile()


func _input_event(_viewport, event, _shape_idx) -> void:
	if not is_clickable: return
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		emit_signal("clicked", self)


func _cost_to_string() -> String:
	if move_cost < 0: return ""
	if move_cost == 0: return "FREE"
	if is_clickable: return "⚡%dPJ" % move_cost
	return "(⚡%dPJ)" % move_cost


func update_visual() -> void:
	if is_active and not _has_been_visited: _has_been_visited = true
	var new_color : Color
	if is_active: new_color = Color(0.5, 0.5, 0.5, 0)     
	elif _has_been_visited: new_color = Color(0.5, 0.5, 0.5, 0)          
	elif is_clickable: new_color = Color(0.5, 0.5, 0.5, 0.5)               
	else: new_color = Color(0.5, 0.5, 0.5, 0.8)  
	var tween_poly := create_tween()
	tween_poly.tween_property($Polygon2D, "color", new_color, 1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	var tween_label := create_tween()
	tween_label.tween_property($Label, "modulate", Color(1, 1, 1, 0), 1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween_label.tween_callback(func(): $Label.text = _cost_to_string())
	tween_label.tween_property($Label, "modulate", Color(1, 1, 1, 1), 1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)


func _on_mouse_entered() -> void:
	if not is_clickable: return
	$Line2D.width = 5
	$Line2D.default_color = Color(1, 1, 0, 0.8)

func _on_mouse_exited() -> void:
	$Line2D.width = 3
	$Line2D.default_color = Color(1, 1, 0, 0.25)
