extends TextureButton

var _mouse_holding: bool = false
@onready var escape_lbl: Control = $Label


func _ready():
	GameState.energy_changed.connect(_on_energy_changed)

func _on_energy_changed(value):
	visible = GameState.active_tile_type == "D"
	if value<400:
		self.disabled = true
		self.mouse_default_cursor_shape = Control.CURSOR_ARROW
		escape_lbl.modulate.a = 0.3
	else:
		self.disabled = false
		self.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		escape_lbl.modulate.a = 1
	

func _on_button_down() -> void:
	escape_lbl.anchor_bottom = 0.95
	_mouse_holding = true
	
func _on_button_up() -> void:
	escape_lbl.anchor_bottom = 0.85
	_mouse_holding = false

func _on_mouse_exited() -> void:
	if _mouse_holding: escape_lbl.anchor_bottom = 0.9

func _on_mouse_entered() -> void:
	if _mouse_holding: escape_lbl.anchor_bottom = 1

func _on_pressed() -> void:
	print("ol")
	get_tree().change_scene_to_file("res://final/final_win.tscn")
