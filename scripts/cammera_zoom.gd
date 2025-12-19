extends Control

@onready var slider = $HSlider

func _ready():
	slider.value = 1.0
	slider.value_changed.connect(_on_h_slider_value_changed)

func _on_h_slider_value_changed(new_value: float) -> void:
	GameState.zoom_changed.emit(new_value)
