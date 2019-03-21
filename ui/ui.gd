extends Control

var score := 0

func _ready():
	$CurrentScore.text = str(score)

func reset():
	score = 0

func on_scored():
	score += 1
	$CurrentScore.text = str(score)