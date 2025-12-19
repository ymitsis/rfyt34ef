extends Panel

var last_width: float

func _ready():
	last_width = size.x
	resized.connect(_on_resized)

func _on_resized():
	var new_width: float = size.x
	var factor: float = new_width / last_width

	for child in get_children():
		if child is Control:

			# Pivot υπολογισμός βασισμένος στα anchors (AUTO)
			var pivot: Vector2 = Vector2(child.anchor_left, child.anchor_top) * size

			# Μετατόπιση αναλογικά με pivot
			child.position = pivot + (child.position - pivot) * factor

			# Scale και στις 2 διαστάσεις
			child.scale *= Vector2(factor, factor)

	last_width = new_width
