extends Node2D

@export var enemy: PackedScene
@onready var spawn_timer := $Timer
@onready var minigame := get_parent()

#spawns the enemy
func _on_timer_timeout() -> void:
	var ene = enemy.instantiate()
	ene.position = Vector2(randf_range(-400, 400), 0)
	add_child(ene)
	var num = randf_range(0.1, 1)
	spawn_timer.set_wait_time(num)
	if minigame.end_of_challenge: spawn_timer.stop()
