extends CanvasLayer

var slider_source_img: Image

func _ready():
	var tex := load("res://ui/slider_grab_a.png") as Texture2D
	slider_source_img = tex.get_image()
	_on_zoom_panel_resized()
	_on_zoom_slider_value_changed(1.0)
	var lang_btn: PopupMenu = $Main_panel/Options_panel/lang.get_popup()
	lang_btn.id_pressed.connect(_on_lang_item_pressed)
	var popup1: PopupMenu = $MenuButton1.get_popup()
	popup1.id_pressed.connect(_on_menu_item_pressed1)
	var popup2: PopupMenu = $MenuButton2.get_popup()
	popup2.id_pressed.connect(_on_menu_item_pressed2)
	var popup3: PopupMenu = $MenuButton3.get_popup()
	popup3.id_pressed.connect(_on_menu_item_pressed3)
	var popup4: PopupMenu = $MenuButton4.get_popup()
	popup4.id_pressed.connect(_on_menu_item_pressed4)
	GameState.quiz_requested.connect(_on_quiz_requested)
	GameState.challenge_requested.connect(_on_challenge_requested)

func _on_quiz_requested(quiz_number: int) -> void:
	var path: String = "res://quizzes/quiz%02d/Quiz%02d.tscn" % [quiz_number, quiz_number]
	show_scene(path)

func _on_challenge_requested():
	show_scene("res://quizzes/challenge/challenge.tscn")

# προχειρο μενου για να τρεχουν τα quiz
func _on_menu_item_pressed1(id: int):
	if id == 0: show_scene("res://quizzes/quiz01/Quiz01.tscn")
	if id == 1: show_scene("res://quizzes/quiz02/Quiz02.tscn")
	if id == 2: show_scene("res://quizzes/quiz03/Quiz03.tscn")
	if id == 3: show_scene("res://quizzes/quiz04/Quiz04.tscn")
	if id == 4: show_scene("res://quizzes/quiz05/Quiz05.tscn")
	if id == 5: show_scene("res://quizzes/quiz06/Quiz06.tscn")
	if id == 6: show_scene("res://quizzes/quiz07/Quiz07.tscn")
	if id == 7: show_scene("res://quizzes/quiz08/Quiz08.tscn")
	if id == 8: show_scene("res://quizzes/quiz09/Quiz09.tscn")
	if id == 9: show_scene("res://quizzes/quiz10/Quiz10.tscn")

func _on_menu_item_pressed2(id: int):
	if id == 0: show_scene("res://quizzes/quiz11/Quiz11.tscn")
	if id == 1: show_scene("res://quizzes/quiz12/Quiz12.tscn")
	if id == 2: show_scene("res://quizzes/quiz13/Quiz13.tscn")
	if id == 3: show_scene("res://quizzes/quiz14/Quiz14.tscn")
	if id == 4: show_scene("res://quizzes/quiz15/Quiz15.tscn")
	if id == 5: show_scene("res://quizzes/quiz16/Quiz16.tscn")
	if id == 6: show_scene("res://quizzes/quiz17/Quiz17.tscn")
	if id == 7: show_scene("res://quizzes/quiz18/Quiz18.tscn")
	if id == 8: show_scene("res://quizzes/quiz19/Quiz19.tscn")
	if id == 9: show_scene("res://quizzes/quiz20/Quiz20.tscn")

func _on_menu_item_pressed3(id: int):
	if id == 0: show_scene("res://quizzes/quiz21/Quiz21.tscn")
	if id == 1: show_scene("res://quizzes/quiz22/Quiz22.tscn")
	if id == 2: show_scene("res://quizzes/quiz23/Quiz23.tscn")
	if id == 3: show_scene("res://quizzes/quiz24/Quiz24.tscn")
	if id == 4: show_scene("res://quizzes/quiz25/Quiz25.tscn")
	if id == 5: show_scene("res://quizzes/quiz26/Quiz26.tscn")
	if id == 6: show_scene("res://quizzes/quiz27/Quiz27.tscn")
	if id == 7: show_scene("res://quizzes/quiz28/Quiz28.tscn")
	if id == 8: show_scene("res://quizzes/quiz29/Quiz29.tscn")
	if id == 9: show_scene("res://quizzes/quiz30/Quiz30.tscn")

func _on_menu_item_pressed4(id: int):
	if id == 0: show_scene("res://quizzes/quiz31/Quiz31.tscn")
	if id == 1: show_scene("res://quizzes/quiz32/Quiz32.tscn")
	if id == 2: show_scene("res://quizzes/quiz33/Quiz33.tscn")
	if id == 3: show_scene("res://quizzes/quiz34/Quiz34.tscn")
	if id == 4: show_scene("res://quizzes/quiz35/Quiz35.tscn")
	if id == 5: show_scene("res://quizzes/quiz36/Quiz36.tscn")
	if id == 6: show_scene("res://quizzes/quiz37/Quiz37.tscn")
	if id == 7: show_scene("res://quizzes/quiz38/Quiz38.tscn")
#	if id == 8: show_scene("res://quizzes/quiz39/Quiz39.tscn")
#	if id == 9: show_scene("res://quizzes/challenge/challenge.tscn")

func show_scene(path: String) -> void:
	var scene: PackedScene = load(path)
	var inst: Node = scene.instantiate()
	add_child(inst)

# ο zoom slider ενημερωνει gamestate για την τιμη του (0,1)
func _on_zoom_slider_value_changed(value: float) -> void:
	GameState.board_zoom_normalized = value

# pause μουσικης και mute ήχου
func _on_sound_button_toggled(toggled_on: bool):
	$Bg_music.stream_paused = toggled_on
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), toggled_on)

# κατα το resize πρέπει να τρεξει ο setter του GameState.board_zoom_normalized
func _on_main_panel_resized() -> void:
	GameState.board_zoom_normalized = GameState.board_zoom_normalized

func _on_window_size_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_lang_item_pressed(id: int):
	if id == 0: TranslationServer.set_locale("el")
	if id == 1: TranslationServer.set_locale("en")

func _on_options_panel_resized() -> void:
	var p: Control = $Main_panel/Options_panel
	var a: Control = p.get_child(0) as Control
	var b: Control = p.get_child(1) as Control
	var c: Control = p.get_child(2) as Control
	var base_m: float = 5.0
	var s: float = p.size.y / (a.size.y + base_m * 2.0)
	var m: float = base_m * s
	a.scale = Vector2(s, s)
	b.scale = Vector2(s, s)
	c.scale = Vector2(s, s)
	a.position = Vector2(m, m)
	c.position = Vector2(p.size.x - c.size.x * s - m, m)
	b.position = Vector2((p.size.x - b.size.x * s) * 0.5, m)

func _on_zoom_panel_resized() -> void:
	if slider_source_img == null: return
	var slider := $Main_panel/Zoom_panel/Zoom_slider
	var panel := $Main_panel/Zoom_panel
	var h: int = int(0.8*panel.size.y)
	var img := slider_source_img.duplicate()
	img.resize(h, h, Image.INTERPOLATE_LANCZOS)
	var tex := ImageTexture.create_from_image(img)
	slider.add_theme_icon_override("grabber", tex)
	slider.add_theme_icon_override("grabber_highlight", tex)
	var thickness: int = int(h*0.4)
	var sb: StyleBoxFlat = slider.get_theme_stylebox("slider").duplicate()
	sb.content_margin_top = thickness/2.0
	sb.content_margin_bottom = thickness/2.0
	slider.add_theme_stylebox_override("slider", sb)
