extends Control

var end_of_challenge: bool = false
var damage: float = 0
var energy_loss: int = 0 

func _ready():
	var t := create_tween()
	t.tween_property($music, "volume_db", -6.0, 5.0)

func _on_right_button_down() -> void:
	Input.action_press("ui_right")

func _on_right_button_up() -> void:
	Input.action_release("ui_right")

func _on_left_button_down() -> void:
	Input.action_press("ui_left")

func _on_left_button_up() -> void:
	Input.action_release("ui_left")

func _show_losses() -> void:
	var t := create_tween()
	t.tween_property($music, "volume_db", -20.0, 30.0)
	t.finished.connect(func(): $music.stream_paused = true)
	energy_loss = floor(min(damage, 100.0)*GameState.energy/100)
	$Dialog.visible = true
	$Dialog/Label2.text = tr("CHALLENGE_END2") % energy_loss

func _on_timer_timeout() -> void:
	if end_of_challenge:
		$Timer.stop()
		_show_losses()
		return
	end_of_challenge = true
	$Timer.start(8)

func _on_btn_ok_button_up() -> void:
	$Dialog/btn_ok/Label.modulate.a = 1.0

func _on_btn_ok_button_down() -> void:
	$Dialog/btn_ok/Label.modulate.a = 0.7

func _on_btn_ok_pressed() -> void:
	var t := create_tween()
	t.parallel().tween_property($music, "volume_db", -30.0, 1.0)
	t.parallel().tween_property(get_owner(), "modulate:a", 0.0, 1.0)
	t.finished.connect(func():
		GameState.energy -= energy_loss
		GameState.game_mode = "board"
		get_owner().queue_free()
	)
