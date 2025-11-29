extends Node2D

var _frame_counter: int
var is_moving: bool:
	set(value): is_moving = value; set_process(value)
var new_target: Vector2:
	set(value): new_target = value; _goto_target()
	
func init_player() -> void:
	_frame_counter = 0
	$ExhaustLeft.scale = Vector2(0.7, 0.0)
	$ExhaustRight.scale = Vector2(0.7, 0.0)
	rotation = 0
	is_moving = false


func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	_frame_counter += 1
	if _frame_counter % 5 != 0: return
	var r := randf_range(0.95, 1.05)
	$ExhaustLeft.scale *= Vector2(r, r);
	$ExhaustRight.scale *= Vector2(r, r)


func _goto_target() -> void:
	var delta_angle := wrapf((new_target - global_position).angle() - rotation + PI / 2.0, -PI, PI)
	var new_angle := rotation + delta_angle
	var left_delay := 0.0; var right_delay := 0.0
	if delta_angle > 0.0: right_delay = 0.2
	if delta_angle < 0.0: left_delay = 0.2
	is_moving = true
	$AudioStreamPlayer.play() 
	var tween := create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT).set_parallel(true)
	tween.tween_property($ExhaustLeft,  "scale", Vector2(1.0, 1.0), 0.2).set_delay(left_delay)
	tween.tween_property($ExhaustRight, "scale", Vector2(1.0, 1.0), 0.2).set_delay(right_delay)
	tween.tween_property(self, "rotation", new_angle, 1.0)
	tween.tween_property(self, "global_position", new_target, 3)
	tween.tween_property($ExhaustLeft,  "scale", Vector2(0.7, 0.0), 2).set_delay(2)
	tween.tween_property($ExhaustRight, "scale", Vector2(0.7, 0.0), 2).set_delay(2)
	tween.finished.connect(func(): is_moving = false)
