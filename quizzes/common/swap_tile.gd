extends TextureRect
class_name SwapTile

signal clicked(tile: SwapTile)

var tile_index: int = -1

var is_selected: bool = false:
	set(v):
		is_selected = v
		queue_redraw()

var show_border: bool = true:
	set(v):
		show_border = v
		queue_redraw()

var is_dimmed: bool = false:
	set(v):
		is_dimmed = v
		queue_redraw()

func _ready() -> void:
	gui_input.connect(_on_gui_input)
	queue_redraw()

func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED: queue_redraw()

func _draw() -> void:
	var rect := Rect2(Vector2.ZERO, size)
	if is_dimmed:
		draw_rect(rect, Color(0.5, 0.5, 0.5, 0.5), true)
	if not show_border: return
	var c := Color(0, 0.8, 1, 1) if is_selected else Color(0.5, 0.5, 0.5, 1)
	var w := 5 if is_selected else 1
	draw_rect(rect, c, false, w, true)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		clicked.emit(self)

func set_locked(locked: bool) -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE if locked else Control.MOUSE_FILTER_STOP

func set_dimmed(dimmed: bool) -> void:
	is_dimmed = dimmed
