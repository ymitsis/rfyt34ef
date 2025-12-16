extends Control


func _on_texture_button_toggled(toggled_on: bool) -> void:
	BgMusic.stream_paused = toggled_on
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), toggled_on)
