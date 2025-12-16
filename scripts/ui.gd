extends CanvasLayer

func _ready():
	var popup: PopupMenu = $MenuButton.get_popup()
	popup.id_pressed.connect(_on_menu_item_pressed)

func _on_menu_item_pressed(id: int) -> void:
	var scene: PackedScene
	if id == 0: scene = load("res://scenes/quizzes/Quiz01.tscn")
	if id == 1: scene = load("res://scenes/quizzes/Quiz02.tscn")
	if id == 2: scene = load("res://scenes/quizzes/Quiz03.tscn")
	if id == 3: scene = load("res://scenes/quizzes/Quiz04.tscn")
	var inst: Node = scene.instantiate()
	add_child(inst)
