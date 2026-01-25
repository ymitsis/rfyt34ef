extends TextureRect


func _on_resized() -> void:
	const BASE = Vector2(276, 98)
	var vp = get_viewport_rect().size
	var scale_factor = min(0.2 * vp.x / BASE.x, 0.2 * vp.y / BASE.y)
	$Label.scale = Vector2(scale_factor, scale_factor)
	$Label.position = (Vector2(20, 20)) * scale_factor
	$Restart_btn.scale = Vector2(scale_factor, scale_factor)
	$Restart_btn.position = (vp - (BASE + Vector2(20, 20)) * scale_factor)


func _on_restart_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://intro/intro.tscn")
