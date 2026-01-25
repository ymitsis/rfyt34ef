extends ColorRect

func _ready():
	get_viewport().size_changed.connect(_on_resize)
	_on_resize()
	modulate.a = 0.0
	var t := create_tween()
	t.tween_property(self, "modulate:a", 1.0, 1)

func _on_resize():
	const BASE = Vector2(800, 800)
	var vp = get_viewport_rect().size
	var scale_factor = min(vp.x, vp.y) / BASE.x
	$minigameWraper.scale = Vector2.ONE * scale_factor
	$minigameWraper.position = (vp - (BASE * scale_factor)) * 0.5
