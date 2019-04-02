extends MarginContainer

onready var current_score_label := find_node("CurrentScore") as Label

var current_score := 0

func _ready():
	reset()

func reset():
	current_score = 0
	update_current_score()

func on_scored():
	current_score += 1
	update_current_score()

func update_current_score():
	current_score_label.text = String(current_score)