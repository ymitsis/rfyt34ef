# UI controller για τη ρύθμιση ήχου.
# Διαχειρίζεται το mute / unmute της μουσικής και του master audio bus
# μέσω toggle button στο interface.
extends Control

# Ενεργοποιεί ή απενεργοποιεί τον ήχο του παιχνιδιού
# κάνοντας pause στη μουσική και mute στο Master audio bus
func _on_texture_button_toggled(toggled_on: bool):
	BgMusic.stream_paused = toggled_on
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), toggled_on)
