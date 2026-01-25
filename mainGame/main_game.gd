extends Node2D

func init():
	GameState.energy = 80
	GameState.reset_quiz_pool()
	GameState.answered_questions = 0
	GameState.challenges = 0
	$Board.init()


func _ready():
	init()
