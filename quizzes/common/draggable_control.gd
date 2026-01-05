extends Control

@export var energy_if_in_stogage: int = 0
@export var correct_dropzone: DropZone
@export var energy_if_correct: int = 4
@export var energy_if_uncorrect: int = -1
@export var correct_position: int = -1

var energy_won : int = 0

func _ready() -> void:
	$EnergyLabel.visible = false
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
	return {	"drag_obj": self, "grab_offset": at_position, "source_zone": get_parent()}
