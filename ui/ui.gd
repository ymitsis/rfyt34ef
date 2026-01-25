extends CanvasLayer

var slider_source_img: Image

func _ready():
	var tex := load("res://ui/slider_grab.png") as Texture2D
	slider_source_img = tex.get_image()
	_on_main_panel_resized()
	_on_energy_panel_resized()
	_on_boost_panel_resized()
	_on_zoom_panel_resized()
	_on_options_panel_resized()
	_on_zoom_slider_value_changed(1.0)
	$Main_panel/Options_panel/Sound_toggle.set_pressed_no_signal(AudioServer.is_bus_mute(AudioServer.get_bus_index("Master")))
	$Main_panel/Options_panel/window_size.set_pressed_no_signal(DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN)
	var lang_btn: PopupMenu = $Main_panel/Options_panel/lang_toggle/lang.get_popup()
	lang_btn.id_pressed.connect(_on_lang_item_pressed)
	lang_btn.popup_hide.connect(_on_lang_popup_closed)
	var popup1: PopupMenu = $MenuButton1.get_popup()
	popup1.id_pressed.connect(_on_menu_item_pressed1)
	GameState.quiz_requested.connect(_on_quiz_requested)
	GameState.challenge_requested.connect(_on_challenge_requested)
	GameState.game_mode_changed.connect(_on_game_mode_changed)

func _on_game_mode_changed(mode) -> void:
	if mode=="board":
		$Bg_music.stream_paused = false
		var t := create_tween()
		t.tween_property($Bg_music, "volume_db", 0.0, 5.0)
	elif mode=="quiz":
		return
	else:
		var t := create_tween()
		t.tween_property($Bg_music, "volume_db", -20.0, 5.0)
		t.finished.connect(func(): $Bg_music.stream_paused = true)

func _on_quiz_requested(quiz_number: int) -> void:
	var path: String = "res://quizzes/quiz%02d/Quiz%02d.tscn" % [quiz_number, quiz_number]
	show_scene(path)

func _on_challenge_requested():
	show_scene("res://challenge/challenge.tscn")

# προχειρο μενου για να τρεχουν τα quiz
func _on_menu_item_pressed1(id: int):
	if id == 00: GameState.energy += 100
	if id == 01: show_scene("res://challenge/challenge.tscn")
	
	if id == 03: show_scene("res://quizzes/quiz01/Quiz01.tscn")
	if id == 04: show_scene("res://quizzes/quiz02/Quiz02.tscn")
	if id == 05: show_scene("res://quizzes/quiz03/Quiz03.tscn")
	if id == 06: show_scene("res://quizzes/quiz04/Quiz04.tscn")
	if id == 07: show_scene("res://quizzes/quiz05/Quiz05.tscn")
	if id == 08: show_scene("res://quizzes/quiz06/Quiz06.tscn")
	if id == 09: show_scene("res://quizzes/quiz07/Quiz07.tscn")
	if id == 10: show_scene("res://quizzes/quiz08/Quiz08.tscn")
	if id == 11: show_scene("res://quizzes/quiz09/Quiz09.tscn")
	if id == 12: show_scene("res://quizzes/quiz10/Quiz10.tscn")
	if id == 13: show_scene("res://quizzes/quiz11/Quiz11.tscn")
	if id == 14: show_scene("res://quizzes/quiz12/Quiz12.tscn")
	if id == 15: show_scene("res://quizzes/quiz13/Quiz13.tscn")
	if id == 16: show_scene("res://quizzes/quiz14/Quiz14.tscn")
	if id == 17: show_scene("res://quizzes/quiz15/Quiz15.tscn")
	if id == 18: show_scene("res://quizzes/quiz16/Quiz16.tscn")
	if id == 19: show_scene("res://quizzes/quiz17/Quiz17.tscn")
	if id == 10: show_scene("res://quizzes/quiz18/Quiz18.tscn")
	if id == 21: show_scene("res://quizzes/quiz19/Quiz19.tscn")
	if id == 22: show_scene("res://quizzes/quiz20/Quiz20.tscn")
	if id == 23: show_scene("res://quizzes/quiz21/Quiz21.tscn")
	if id == 24: show_scene("res://quizzes/quiz22/Quiz22.tscn")
	if id == 25: show_scene("res://quizzes/quiz23/Quiz23.tscn")
	if id == 26: show_scene("res://quizzes/quiz24/Quiz24.tscn")
	if id == 27: show_scene("res://quizzes/quiz25/Quiz25.tscn")
	if id == 28: show_scene("res://quizzes/quiz26/Quiz26.tscn")
	if id == 29: show_scene("res://quizzes/quiz27/Quiz27.tscn")
	if id == 30: show_scene("res://quizzes/quiz28/Quiz28.tscn")
	if id == 31: show_scene("res://quizzes/quiz29/Quiz29.tscn")
	if id == 32: show_scene("res://quizzes/quiz30/Quiz30.tscn")
	if id == 33: show_scene("res://quizzes/quiz31/Quiz31.tscn")
	if id == 34: show_scene("res://quizzes/quiz32/Quiz32.tscn")
	if id == 35: show_scene("res://quizzes/quiz33/Quiz33.tscn")
	if id == 36: show_scene("res://quizzes/quiz34/Quiz34.tscn")
	if id == 37: show_scene("res://quizzes/quiz35/Quiz35.tscn")
	if id == 38: show_scene("res://quizzes/quiz36/Quiz36.tscn")
	if id == 39: show_scene("res://quizzes/quiz37/Quiz37.tscn")
	if id == 40: show_scene("res://quizzes/quiz38/Quiz38.tscn")
	
	

func show_scene(path: String) -> void:
	var scene: PackedScene = load(path)
	var inst: Node = scene.instantiate()
	add_child(inst)
	GameState.game_mode = "quiz"

# ο zoom slider ενημερωνει gamestate για την τιμη του (0,1)
func _on_zoom_slider_value_changed(value: float) -> void:
	GameState.board_zoom_normalized = value

# pause μουσικης και mute ήχου
func _on_sound_button_toggled(toggled_on: bool):
	$Bg_music.stream_paused = toggled_on
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), toggled_on)


func _on_main_panel_resized() -> void:
	GameState.board_zoom_normalized = GameState.board_zoom_normalized
	var main_panel: Control = $Main_panel
	var energy_panel: Control = $Main_panel/Energy_panel
	var escape_panel: Control = $Main_panel/Escape_panel
	var zoom_panel: Control = $Main_panel/Zoom_panel
	var opt_panel: Control = $Main_panel/Options_panel
	var hgt: float = min(main_panel.size.x * 0.2, main_panel.size.y * 0.1)
	var wdt: float = main_panel.size.x * 0.9
	var mrg: float = main_panel.size.x * 0.05
	energy_panel.size = Vector2(wdt, 3.9 * hgt)
	energy_panel.position.x = mrg
	escape_panel.size = Vector2(wdt, 2 * hgt)
	escape_panel.position.x = mrg
	zoom_panel.size = Vector2(wdt, hgt)
	zoom_panel.position.x = mrg
	opt_panel.size = Vector2(wdt, hgt)
	opt_panel.position.x = mrg
	energy_panel.position.y = 0.3 * hgt
	opt_panel.position.y = main_panel.size.y - opt_panel.size.y * 1.3
	zoom_panel.position.y = opt_panel.position.y - zoom_panel.size.y * 1.5
	escape_panel.position.y = main_panel.size.y/2

func _on_window_size_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_lang_item_pressed(id: int):
	if id == 0: TranslationServer.set_locale("el")
	if id == 1: TranslationServer.set_locale("en")
	
func _on_lang_popup_closed():
	$Main_panel/Options_panel/lang_toggle.button_pressed = false

func _on_options_panel_resized() -> void:
	var p: Control = $Main_panel/Options_panel
	var a: Control = p.get_child(0) as Control
	var b: Control = p.get_child(1) as Control
	var c: Control = p.get_child(2) as Control
	var d: Control = p.get_child(3) as Control
	var s: float = p.size.y / a.size.y
	a.scale = Vector2(s, s)
	b.scale = Vector2(s, s)
	c.scale = Vector2(s, s)
	d.scale = Vector2(s, s)
	var w = a.size.x * s
	var gap = (p.size.x - 4 * w) / 3.0
	a.position = Vector2(0, 0)
	b.position = Vector2(a.position.x + w + gap, 0)
	c.position = Vector2(b.position.x + w + gap, 0)
	d.position = Vector2(c.position.x + w + gap, 0)

func _on_zoom_panel_resized() -> void:
	if slider_source_img == null: return
	var slider := $Main_panel/Zoom_panel/Zoom_slider
	var panel := $Main_panel/Zoom_panel
	var img := slider_source_img.duplicate()
	var src_w: int = img.get_width()
	var src_h: int = img.get_height()
	var h: int = panel.size.y
	var w: int = int(round(float(src_w) * float(h) / float(src_h)))
	img.resize(w, h, Image.INTERPOLATE_LANCZOS)
	var tex := ImageTexture.create_from_image(img)
	slider.add_theme_icon_override("grabber", tex)
	slider.add_theme_icon_override("grabber_highlight", tex)
	
func _on_boost_panel_resized() -> void:
	var panel: Control = $Main_panel/Escape_panel
	var escape_btn: Control = $Main_panel/Escape_panel/Escape_btn
	var s: float = panel.size.y / escape_btn.size.y
	escape_btn.scale = Vector2(s, s)
	escape_btn.position = Vector2((panel.size.x - escape_btn.size.x * s)/2, 0)


func _on_energy_panel_resized() -> void:
	var panel: Control = $Main_panel/Energy_panel
	var gauge: Control = $Main_panel/Energy_panel/Energy_gauge
	var s: float = panel.size.y / gauge.size.y
	gauge.scale = Vector2(s, s)
	gauge.position = Vector2((panel.size.x - gauge.size.x * s)/2, 0)


func _on_restart_pressed() -> void:
	get_tree().change_scene_to_file("res://intro/intro.tscn")
