extends TextureButton

@export var _sound_file: AudioStream
@export var _loop_sound: bool

var _master_mute : bool

func _ready() -> void:
	$audio.stream = _sound_file
	$audio.stream.loop = _loop_sound
	_master_mute = AudioServer.is_bus_mute(AudioServer.get_bus_index("Master"))
	$audio.play()
	$audio.stream_paused = true

func _on_toggled(toggled_on: bool) -> void:
	if _master_mute: AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), !toggled_on)
	$audio.stream_paused = !toggled_on

func _on_tree_exiting() -> void:
	if _master_mute: AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
