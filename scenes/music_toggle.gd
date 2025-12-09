extends Control

func _on_texture_button_pressed() -> void:
	if BgMusic.playing == true:
		BgMusic.stop()
	else:
		BgMusic.play()
	
