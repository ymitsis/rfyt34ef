extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameState.zoom_changed.connect(_on_zoom_changed)

func _on_zoom_changed(value):
	zoom = Vector2(value,value)
