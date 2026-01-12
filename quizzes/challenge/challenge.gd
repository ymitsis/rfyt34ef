extends ColorRect

func _ready():
	get_viewport().size_changed.connect(_on_resize)
	_on_resize() 
	$Container/option1_btn/option1_lbl.text = tr("CHALLENGE_OPTION1") % ceili(GameState.energy * 0.2)

func _on_resize():
	const BASE = Vector2(800, 450)
	const MARGIN = 0.2
	var vp = get_viewport_rect().size
	var avail = vp * (1.0 - MARGIN * 2.0)
	var scale_factor = min(avail.x / BASE.x, avail.y / BASE.y)
	$Container.scale = Vector2(scale_factor, scale_factor)
	$Container.position = (vp - BASE * scale_factor) * 0.5

func _on_option_1_btn_pressed() -> void:
	GameState.energy -= ceili(GameState.energy*0.2)
	queue_free()

func _on_option_2_btn_pressed() -> void:
	var path: String = "res://quizzes/challenge/mini_game.tscn"
	var scene: PackedScene = load(path) as PackedScene
	var new_node := scene.instantiate()
	get_parent().add_child(new_node)
	queue_free()
