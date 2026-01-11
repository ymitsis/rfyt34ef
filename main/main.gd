extends Node2D

func init():
	GameState.energy = 100
	TranslationServer.set_locale("en")
	$Board.init()


func _ready():
	init()
