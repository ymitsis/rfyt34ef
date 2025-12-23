extends Control

@export var energy_if_in_stogage: int = 0
@export var correct_dropzone: DropZone
@export var energy_if_correct: int = 4
@export var energy_if_uncorrect: int = -1

var energy_won : int = 0

func _ready() -> void:
	$EnergyLabel.visible = false
	add_to_group("draggablesB")

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
	return {	"drag_obj": self, "grab_offset": at_position, "source_zone": get_parent()}

func _on_tree_entered() -> void:
	if get_parent() is DropZone:
		var energy_label: Label = $EnergyLabel
		var myDZone : DropZone = get_parent()
		if myDZone == correct_dropzone: energy_won = energy_if_correct
		elif myDZone.is_storage: energy_won = energy_if_in_stogage
		else: energy_won = energy_if_uncorrect
		var s := ""; var c: Color
		if energy_won < 0: c = Color(0.8, 0, 0)
		elif energy_won > 0: c = Color(0, 0.8, 0); s = "+"
		else: c = Color(0.4, 0.4, 0.4)
		energy_label.add_theme_color_override("font_outline_color", c)
		energy_label.text = "⚡" + s + str(energy_won)
