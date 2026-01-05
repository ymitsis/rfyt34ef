extends Node2D

func init():
	GameState.energy = 999
	$Board.init()


func _ready():
	init()
