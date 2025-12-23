extends CanvasLayer

func _ready():
	var popup: PopupMenu = $MenuButton.get_popup()
	popup.id_pressed.connect(_on_menu_item_pressed)

#προχειρο μενου για να τρεχουν τα quiz
func _on_menu_item_pressed(id: int):
	var scene: PackedScene
	if id == 0: scene = load("res://scenes/quizzes/Quiz01.tscn")
	if id == 1: scene = load("res://scenes/quizzes/Quiz02.tscn")
	if id == 2: scene = load("res://scenes/quizzes/Quiz03.tscn")
	if id == 3: scene = load("res://scenes/quizzes/Quiz04.tscn")
	var inst: Node = scene.instantiate()
	add_child(inst)

#ο zoom slider ενημερωνει gamestate για την τιμη του (0,1)
func _on_zoom_slider_value_changed(value: float) -> void:
	GameState.board_zoom_normalized = value

#pouse μουσικης και mute ήχου
func _on_sound_button_toggled(toggled_on: bool):
	$Bg_music.stream_paused = toggled_on
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), toggled_on)

#κατα το resize πρέπει να τρεξει ο setter του GameState.board_zoom_normalized για να προσαρμονσει το zooom στο νεο παραθυρο
func _on_main_panel_resized() -> void:
	GameState.board_zoom_normalized = GameState.board_zoom_normalized


func _on_window_size_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
