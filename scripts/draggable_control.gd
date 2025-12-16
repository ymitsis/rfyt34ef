extends Control

var home_position: Vector2

func _ready() -> void:
	home_position = position
	add_to_group("draggables")


func _get_drag_data(at_position: Vector2) -> Variant:
	var preview := Control.new()
	var clone := self.duplicate()
	preview.add_child(clone)
	var s := get_global_transform().get_scale()
	preview.scale = s
	preview.size = size
	clone.position = -at_position
	clone.modulate.a = 0.5
	set_drag_preview(preview)
	return {"drag_obj": self, "grab_offset": at_position}
