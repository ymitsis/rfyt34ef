# Player controller.
# Διαχειρίζεται την κίνηση του παίκτη πάνω στο board, τον προσανατολισμό,
# τα thrusters (exhaust) και το animation / ήχο κατά τη μετακίνηση.
extends Node2D
class_name Player

@onready var _exhaust_left: Sprite2D = $ExhaustLeft
@onready var _exhaust_right: Sprite2D = $ExhaustRight


var _frame_counter: int
var is_moving: bool:
	set(value): is_moving = value; set_process(value)
var new_target: Vector2:
	set(value): new_target = value; _goto_target()

# Αρχικοποιηση
func init():
	_frame_counter = 0
	_exhaust_left.scale = Vector2(0.7, 0.0)
	_exhaust_right.scale = Vector2(0.7, 0.0)
	rotation = 0
	is_moving = false


# Εφαρμόζει μικρό τυχαίο jitter στα thrusters όσο ο παίκτης κινείται
func _process(_delta: float):
	_frame_counter += 1
	if _frame_counter % 5 != 0: return
	var r := randf_range(0.95, 1.05)
	_exhaust_left.scale *= Vector2(r, r);
	_exhaust_right.scale *= Vector2(r, r)


# μετακινεί το διαστημόπλοιο προς τη νέα θεση 
func _goto_target():
	var delta_angle := wrapf((new_target - global_position).angle() - rotation + PI / 2.0, -PI, PI)
	var new_angle := rotation + delta_angle
	var left_delay := 0.0; var right_delay := 0.0
	if delta_angle > 0.0: right_delay = 0.2
	if delta_angle < 0.0: left_delay = 0.2
	is_moving = true
	$AudioStreamPlayer.play() 
	var tween := create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT).set_parallel(true)
	tween.tween_property(_exhaust_left,  "scale", Vector2(1.0, 1.0), 0.2).set_delay(left_delay)
	tween.tween_property(_exhaust_right, "scale", Vector2(1.0, 1.0), 0.2).set_delay(right_delay)
	tween.tween_property(self, "rotation", new_angle, 1.0)
	tween.tween_property(self, "global_position", new_target, 3)
	tween.tween_property(_exhaust_left,  "scale", Vector2(0.7, 0.0), 2).set_delay(2)
	tween.tween_property(_exhaust_right, "scale", Vector2(0.7, 0.0), 2).set_delay(2)
	tween.finished.connect(_tile_arrived)

#Στο τέλος της κινησης καλειται το quiz
func _tile_arrived():
	is_moving = false
	GameState.request_quiz()
