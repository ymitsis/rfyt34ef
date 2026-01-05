extends CanvasLayer

func _ready():
	var popup1: PopupMenu = $MenuButton1.get_popup()
	popup1.id_pressed.connect(_on_menu_item_pressed1)
	var popup2: PopupMenu = $MenuButton2.get_popup()
	popup2.id_pressed.connect(_on_menu_item_pressed2)
	var popup3: PopupMenu = $MenuButton3.get_popup()
	popup3.id_pressed.connect(_on_menu_item_pressed3)
	var popup4: PopupMenu = $MenuButton4.get_popup()
	popup4.id_pressed.connect(_on_menu_item_pressed4)

#προχειρο μενου για να τρεχουν τα quiz
func _on_menu_item_pressed1(id: int):
	var scene: PackedScene
	if id == 0: scene = load("res://quizzes/quiz01/Quiz01.tscn")
	if id == 1: scene = load("res://quizzes/quiz02/Quiz02.tscn")
	if id == 2: scene = load("res://quizzes/quiz03/Quiz03.tscn")
	if id == 3: scene = load("res://quizzes/quiz04/Quiz04.tscn")
	if id == 4: scene = load("res://quizzes/quiz05/Quiz05.tscn")
	if id == 5: scene = load("res://quizzes/quiz06/Quiz06.tscn")
	if id == 6: scene = load("res://quizzes/quiz07/Quiz07.tscn")
	if id == 7: scene = load("res://quizzes/quiz08/Quiz08.tscn")
	if id == 8: scene = load("res://quizzes/quiz09/Quiz09.tscn")
	if id == 9: scene = load("res://quizzes/quiz10/Quiz10.tscn")
	var inst: Node = scene.instantiate()
	add_child(inst)
	
func _on_menu_item_pressed2(id: int):
	var scene: PackedScene
	if id == 0: scene = load("res://quizzes/quiz11/Quiz11.tscn")
	if id == 1: scene = load("res://quizzes/quiz12/Quiz12.tscn")
	if id == 2: scene = load("res://quizzes/quiz13/Quiz13.tscn")
	if id == 3: scene = load("res://quizzes/quiz14/Quiz14.tscn")
	if id == 4: scene = load("res://quizzes/quiz15/Quiz15.tscn")
	if id == 5: scene = load("res://quizzes/quiz16/Quiz16.tscn")
	if id == 6: scene = load("res://quizzes/quiz17/Quiz17.tscn")
	if id == 7: scene = load("res://quizzes/quiz18/Quiz18.tscn")
	if id == 8: scene = load("res://quizzes/quiz19/Quiz19.tscn")
	if id == 9: scene = load("res://quizzes/quiz20/Quiz20.tscn")
	var inst: Node = scene.instantiate()
	add_child(inst)
	
func _on_menu_item_pressed3(id: int):
	var scene: PackedScene
	if id == 0: scene = load("res://quizzes/quiz21/Quiz21.tscn")
	if id == 1: scene = load("res://quizzes/quiz22/Quiz22.tscn")
	if id == 2: scene = load("res://quizzes/quiz23/Quiz23.tscn")
	if id == 3: scene = load("res://quizzes/quiz24/Quiz24.tscn")
	if id == 4: scene = load("res://quizzes/quiz25/Quiz25.tscn")
	if id == 5: scene = load("res://quizzes/quiz26/Quiz26.tscn")
	if id == 6: scene = load("res://quizzes/quiz27/Quiz27.tscn")
	if id == 7: scene = load("res://quizzes/quiz28/Quiz28.tscn")
	if id == 8: scene = load("res://quizzes/quiz29/Quiz29.tscn")
	if id == 9: scene = load("res://quizzes/quiz30/Quiz30.tscn")
	var inst: Node = scene.instantiate()
	add_child(inst)
	
func _on_menu_item_pressed4(id: int):
	var scene: PackedScene
	if id == 0: scene = load("res://quizzes/quiz31/Quiz31.tscn")
	if id == 1: scene = load("res://quizzes/quiz32/Quiz32.tscn")
	if id == 2: scene = load("res://quizzes/quiz33/Quiz33.tscn")
	if id == 3: scene = load("res://quizzes/quiz34/Quiz34.tscn")
	if id == 4: scene = load("res://quizzes/quiz35/Quiz35.tscn")
	if id == 5: scene = load("res://quizzes/quiz36/Quiz36.tscn")
	if id == 6: scene = load("res://quizzes/quiz37/Quiz37.tscn")
	if id == 7: scene = load("res://quizzes/quiz38/Quiz38.tscn")
	if id == 8: scene = load("res://quizzes/quiz39/Quiz39.tscn")
	if id == 9: scene = load("res://quizzes/quiz40/Quiz40.tscn")
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
