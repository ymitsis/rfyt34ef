extends ColorRect

@onready var _continue_btn: TextureButton = $Container/continue
@onready var _submit_btn: TextureButton = $Container/submit
@onready var _result_lbl: Label = $Container/result

var _won_energy : int = 0; 

func _ready():
	_continue_btn.visible = false
	_result_lbl.visible = false
	_on_resize()
	get_viewport().size_changed.connect(_on_resize)

func _on_resize():
	const BASE = Vector2(1100, 600)
	const MARGIN = 0.044
	var vp = get_viewport_rect().size
	var avail = vp * (1.0 - MARGIN * 2.0)
	var scale_factor = min(avail.x / BASE.x, avail.y / BASE.y)
	$Container.scale = Vector2(scale_factor, scale_factor)
	$Container.position = (vp - BASE * scale_factor) * 0.5

func calculate_max_energy() -> int:
	return 0
	
func calculate_won_energy() -> int:
	return 0

func _on_submit_pressed() -> void:
	var max_energy := calculate_max_energy()
	_won_energy = calculate_won_energy()
	if _won_energy < 0: _won_energy = 0
	if _won_energy == max_energy:
		_result_lbl.text = "ΤΕΛΕΙΑ! κέρδισες τη μέγιστη ενέργεια (%dPJ)" % _won_energy
		_result_lbl.add_theme_color_override("font_color", Color(0, 0.6, 0))
	elif _won_energy == 0:
		_result_lbl.text = "δεν κέρδισες ενέργεια αυτή τη φορά…"
		_result_lbl.add_theme_color_override("font_color", Color(0.6, 0, 0))
	else:
		_result_lbl.text = "κέρδισες %dPJ ενέργειας (μέγιστο %dPJ)" % [_won_energy, max_energy]
		_result_lbl.add_theme_color_override("font_color", Color(0.4, 0.4, 0.4))
	_fade_in(_result_lbl)
	_fade_out(_submit_btn)
	_fade_in(_continue_btn)

func set_submit_button_enabled(enabled: bool):
	_submit_btn.disabled = not enabled
	if enabled:
		_submit_btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		$Container/submit/Label.modulate = Color(1, 1, 1, 1)
		_submit_btn.tooltip_text = ""
	else:
		_submit_btn.mouse_default_cursor_shape = Control.CURSOR_ARROW
		$Container/submit/Label.modulate = Color(1, 1, 1, 0.6)
		_submit_btn.tooltip_text = "επέλεξε πρώτα κάτι"

func _on_continue_pressed() -> void:
	GameState.energy += _won_energy
	queue_free()

func _fade_in(node: CanvasItem, duration := 1.0) -> void:
	node.visible = true
	node.modulate.a = 0.0
	var t := create_tween()
	t.tween_property(node, "modulate:a", 1.0, duration)

func _fade_out(node: CanvasItem, duration := 1.0) -> void:
	var t := create_tween()
	t.tween_property(node, "modulate:a", 0.0, duration)
	t.finished.connect(func() -> void: node.visible = false)
