extends Control
class_name DropZone

signal drop_zone_change

@export var is_storage: bool
@export var is_horizontal: bool = false
@export var capacity: int = 100
@export var overflow_zone: DropZone
@export var padding: float = 10.0

var items: Array[Control] =[]

func _ready() -> void:
	add_to_group("drop_zonesB")
	items.clear()
	for child in get_children():
		if child.is_in_group("draggablesB"):
			items.append(child)
	_arrange_items()

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if capacity <= 0: return false
	if !data.has("drag_obj"): return false
	return true

func _remove_item(ctrl: Control) -> void:
	if items.has(ctrl):
		items.erase(ctrl)
		_arrange_items()

func _reparent_keep_global(ctrl: Control, new_parent: Control) -> void:
	var g := ctrl.global_position
	ctrl.get_parent().remove_child(ctrl)
	new_parent.add_child(ctrl)
	ctrl.global_position = g
	await get_tree().process_frame
	ctrl.global_position = g

func _accept_evict(ctrl: Control) -> void:
	if ctrl.get_parent() != self:
		await _reparent_keep_global(ctrl, self)
	items.append(ctrl)
	_arrange_items()

func _arrange_items() -> void:
	if items.is_empty(): return
	var total_size: float = 0.0
	for ctrl in items:
		total_size += ctrl.size.x if is_horizontal else ctrl.size.y
	total_size += padding * (items.size() - 1)
	var cursor: float
	if is_horizontal:
		cursor = (size.x - total_size) * 0.5
	else:
		cursor = (size.y - total_size) * 0.5
	for ctrl in items:
		var target_pos: Vector2
		if is_horizontal:
			target_pos = Vector2(cursor, (size.y - ctrl.size.y) * 0.5)
			cursor += ctrl.size.x + padding
		else:
			target_pos = Vector2((size.x - ctrl.size.x) * 0.5, cursor)
			cursor += ctrl.size.y + padding
		_slide_to(ctrl, target_pos)
	emit_signal("drop_zone_change")

func _center_coord(ctrl: Control) -> float:
	return (ctrl.position.x + ctrl.size.x * 0.5) if is_horizontal else (ctrl.position.y + ctrl.size.y * 0.5)

func _find_insert_index(ctrl: Control) -> int:
	var incoming := _center_coord(ctrl)
	for i in range(items.size()):
		var other: Control = items[i]
		if incoming < _center_coord(other):
			return i
	return items.size()

func _drop_data(at_position: Vector2, data: Variant) -> void:
	var ctrl: Control = data["drag_obj"]
	var grab_offset: Vector2 = data["grab_offset"]
	var source_zone: Control = data["source_zone"]
	source_zone._remove_item(ctrl)
	if ctrl.get_parent() != self:
		await _reparent_keep_global(ctrl, self)
	ctrl.position = at_position - grab_offset
	await get_tree().process_frame
	var evicted: Control = null
	if items.size() >= capacity:
		evicted = items[0]
		items.remove_at(0)
	items.insert(_find_insert_index(ctrl), ctrl)
	_arrange_items()
	if evicted != null and overflow_zone != null:
		await overflow_zone._accept_evict(evicted)

func _slide_to(ctrl: Control, target: Vector2, duration := 0.5) -> void:
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(ctrl, "position", target, duration)
