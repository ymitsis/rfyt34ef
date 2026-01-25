extends TextureRect

func _ready() -> void:
	var lang_btn: PopupMenu = $Options_panel/lang_toggle/lang.get_popup()
	lang_btn.id_pressed.connect(_on_lang_item_pressed)
	lang_btn.popup_hide.connect(_on_lang_popup_closed)
	txt_scroll()
	$Options_panel/Sound_toggle.set_pressed_no_signal(AudioServer.is_bus_mute(AudioServer.get_bus_index("Master")))
	$Options_panel/window_size.set_pressed_no_signal(DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN)

func txt_scroll() -> void:
	var wrapper = $center_container/text_window/txt_wrapper
	var txt: RichTextLabel = $center_container/text_window/txt_wrapper/scroll_text
	var vscroll := txt.get_v_scroll_bar()
	await get_tree().process_frame
	vscroll.modulate.a = 0.0
	vscroll.value = 0.0
	var max_scroll: float = vscroll.max_value - vscroll.page
	var speed: float = 30.0
	txt.position.y = wrapper.size.y
	var enter_time: float = float(wrapper.size.y) / speed
	var scroll_time: float = (2.0 * max_scroll) / speed
	var tween := create_tween()
	tween.tween_property(txt, "position:y", 0.0, enter_time).set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(vscroll, "value", max_scroll, scroll_time).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_callback(func(): vscroll.modulate.a = 1.0)
	

func _on_resized() -> void:
	const CNT_CONT_BASE = Vector2(534, 662)
	const PANEL_BASE = Vector2(200, 50)
	const INFO_BASE = Vector2(765, 500)
	var vp = get_viewport_rect().size
	var scale_factor = min(vp.x / CNT_CONT_BASE.x, vp.y / CNT_CONT_BASE.y)
	$center_container.scale = Vector2(scale_factor, scale_factor)
	$center_container.position = (vp - CNT_CONT_BASE * scale_factor) * 0.5
	var safe_scale_factor = min(scale_factor, vp.x/900)
	$Options_panel.scale = Vector2(safe_scale_factor, safe_scale_factor)
	$Options_panel.position = vp - PANEL_BASE * safe_scale_factor
	scale_factor = min(2, vp.x / (INFO_BASE.x+100), vp.y / (INFO_BASE.y + 100))
	$info/window.scale = Vector2(scale_factor, scale_factor)
	$info/window.position = (vp - INFO_BASE * scale_factor) * 0.5


func _on_sound_toggle_toggled(toggled_on: bool) -> void:
	$Bg_music.stream_paused = toggled_on
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), toggled_on)


func _on_window_size_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		
func _on_lang_item_pressed(id: int):
	if id == 0: TranslationServer.set_locale("el")
	if id == 1: TranslationServer.set_locale("en")

func _on_lang_popup_closed():
	$Options_panel/lang_toggle.button_pressed = false

func _on_okbtn_pressed() -> void:
	$info.visible = false

func _on_info_pressed() -> void:
	$info.visible = true

func _on_start_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://mainGame/MainGame.tscn")
